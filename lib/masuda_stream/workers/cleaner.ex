defmodule MasudaStream.Workers.Cleaner do
  use Oban.Worker, queue: :default, max_attempts: 3
  require Logger
  import Ecto.Query
  alias MasudaStream.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    clean()
  end

  def clean do
    days_to_keep = Application.get_env(:masuda_stream, __MODULE__, []) |> Keyword.get(:days_to_keep, 90)
    cutoff = DateTime.utc_now() |> DateTime.add(-days_to_keep * 24 * 3600, :second)

    old_entry_ids =
      from(e in "hatena_entries", where: e.posted_at < ^cutoff, select: e.id)
      |> Repo.all()

    if old_entry_ids == [] do
      Logger.info("Cleaner: no old entries to delete")
      :ok
    else
      old_detail_ids =
        from(d in "hatena_entry_details", where: d.entry_id in ^old_entry_ids, select: d.id)
        |> Repo.all()

      Ecto.Multi.new()
      |> Ecto.Multi.run(:delete_bookmarks, fn _repo, _changes ->
        {count, _} =
          if old_detail_ids == [] do
            {0, nil}
          else
            from(b in "hatena_entry_bookmarks", where: b.entry_detail_id in ^old_detail_ids)
            |> Repo.delete_all()
          end

        {:ok, count}
      end)
      |> Ecto.Multi.run(:delete_details, fn _repo, _changes ->
        {count, _} =
          from(d in "hatena_entry_details", where: d.entry_id in ^old_entry_ids)
          |> Repo.delete_all()

        {:ok, count}
      end)
      |> Ecto.Multi.run(:delete_anonds, fn _repo, _changes ->
        {count, _} =
          from(a in "anonds", where: a.entry_id in ^old_entry_ids)
          |> Repo.delete_all()

        {:ok, count}
      end)
      |> Ecto.Multi.run(:delete_entries, fn _repo, _changes ->
        {count, _} =
          from(e in "hatena_entries", where: e.id in ^old_entry_ids)
          |> Repo.delete_all()

        {:ok, count}
      end)
      |> Repo.transaction()
      |> case do
        {:ok, result} ->
          Logger.info(
            "Cleaner: deleted #{result.delete_entries} entries, " <>
              "#{result.delete_details} details, " <>
              "#{result.delete_bookmarks} bookmarks, " <>
              "#{result.delete_anonds} anonds"
          )

          MasudaStream.Cache.invalidate_entries()
          :ok

        {:error, step, reason, _changes} ->
          Logger.error("Cleaner: failed at #{step}: #{inspect(reason)}")
          {:error, reason}
      end
    end
  end
end
