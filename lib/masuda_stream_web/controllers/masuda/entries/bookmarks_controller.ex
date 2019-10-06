defmodule MasudaStreamWeb.Masuda.Entries.BookmarksController do
  use MasudaStreamWeb, :controller
  alias MasudaStream.Repo

  def index(conn, %{"entries_id" => entry_id}) do
    detail = MasudaStream.Hatena.EntryDetail
    |> Repo.get_by(entry_id: entry_id)
    |> Repo.preload(:entry_bookmarks)
    render(conn, "index.json", bookmarks: detail.entry_bookmarks)
  end
end
