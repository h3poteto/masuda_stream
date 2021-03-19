defmodule MasudaStreamWeb.Masuda.EntriesController do
  import Ecto.Query
  use Timex
  use MasudaStreamWeb, :controller
  alias MasudaStream.Repo

  def index(conn, %{"before" => before} = _params) do
    since =
      before
      |> String.to_integer(10)
      |> Timex.from_unix()

    entries =
      Repo.all(
        from p in MasudaStream.Hatena.Entry,
          where: p.posted_at < ^since,
          order_by: [desc: p.posted_at],
          limit: 20,
          select: p
      )

    render(conn, "index.json", entries: entries)
  end

  def index(conn, _params) do
    since = Timex.now()

    entries =
      Repo.all(
        from p in MasudaStream.Hatena.Entry,
          where: p.posted_at <= ^since,
          order_by: [desc: p.posted_at],
          limit: 20,
          select: p
      )

    render(conn, "index.json", entries: entries)
  end

  def show(conn, %{"id" => id}) do
    entry =
      Repo.get(MasudaStream.Hatena.Entry, id)
      |> Repo.preload([:anond, :entry_detail])

    render(conn, "show.json", entry: entry)
  end
end
