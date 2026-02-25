defmodule MasudaStreamWeb.Masuda.EntriesController do
  import Ecto.Query
  use Timex
  use MasudaStreamWeb, :controller
  alias MasudaStream.Repo
  alias MasudaStream.Cache

  def index(conn, %{"before" => before} = _params) do
    entries =
      Cache.fetch("entries:before:#{before}", 300, fn ->
        since =
          before
          |> String.to_integer(10)
          |> Timex.from_unix()

        Repo.all(
          from p in MasudaStream.Hatena.Entry,
            where: p.posted_at < ^since,
            order_by: [desc: p.posted_at],
            limit: 20,
            select: p
        )
      end)

    render(conn, "index.json", entries: entries)
  end

  def index(conn, _params) do
    entries =
      Cache.fetch("entries:latest", 300, fn ->
        since = Timex.now()

        Repo.all(
          from p in MasudaStream.Hatena.Entry,
            where: p.posted_at <= ^since,
            order_by: [desc: p.posted_at],
            limit: 20,
            select: p
        )
      end)

    render(conn, "index.json", entries: entries)
  end

  def show(conn, %{"id" => id}) do
    entry =
      Cache.fetch("entry:#{id}", 1800, fn ->
        Repo.get(MasudaStream.Hatena.Entry, id)
        |> Repo.preload([:anond, :entry_detail])
      end)

    render(conn, "show.json", entry: entry)
  end
end
