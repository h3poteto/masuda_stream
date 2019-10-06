defmodule MasudaStreamWeb.Masuda.EntriesController do
  import Ecto.Query
  use MasudaStreamWeb, :controller
  use Timex
  alias MasudaStream.Repo

  def index(conn, _params) do
    before = Timex.now()
    entries = Repo.all(
      from p in MasudaStream.Hatena.Entry,
      where: p.posted_at <= ^before,
      order_by: [desc: p.posted_at],
      limit: 20,
      select: p
    )
    render(conn, "index.json", entries: entries)
  end
end
