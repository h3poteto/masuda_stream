defmodule MasudaStreamWeb.Masuda.Entries.BookmarksController do
  use MasudaStreamWeb, :controller
  alias MasudaStream.Hatena.EntryDetail
  alias MasudaStream.Repo
  alias MasudaStream.Cache

  def index(conn, %{"entries_id" => entry_id}) do
    # TODO: sometimes detail does not exist, because entry has been deleted.
    bookmarks =
      Cache.fetch("bookmarks:#{entry_id}", 600, fn ->
        detail =
          EntryDetail
          |> Repo.get_by(entry_id: entry_id)
          |> Repo.preload(:entry_bookmarks)

        detail.entry_bookmarks
      end)

    render(conn, "index.json", bookmarks: bookmarks)
  end
end
