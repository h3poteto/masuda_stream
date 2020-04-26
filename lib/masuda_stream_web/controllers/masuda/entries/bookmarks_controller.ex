defmodule MasudaStreamWeb.Masuda.Entries.BookmarksController do
  use MasudaStreamWeb, :controller
  alias MasudaStream.Hatena.EntryDetail
  alias MasudaStream.Repo

  def index(conn, %{"entries_id" => entry_id}) do
    # TODO: sometimes detail does not exist, because entry has been deleted.
    detail =
      EntryDetail
      |> Repo.get_by(entry_id: entry_id)
      |> Repo.preload(:entry_bookmarks)

    render(conn, "index.json", bookmarks: detail.entry_bookmarks)
  end
end
