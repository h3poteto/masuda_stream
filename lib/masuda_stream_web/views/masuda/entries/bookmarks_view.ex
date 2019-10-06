defmodule MasudaStreamWeb.Masuda.Entries.BookmarksView do
  use MasudaStreamWeb, :view
  use Timex
  alias MasudaStreamWeb.Masuda.Entries.BookmarksView

  def render("index.json", %{bookmarks: bookmarks}) do
    %{bookmarks: render_many(bookmarks, BookmarksView, "bookmark.json", as: :bookmark)}
  end

  def render("bookmark.json", %{bookmark: bookmark}) do
    %{
      id: bookmark.id,
      comment: bookmark.comment,
      user: bookmark.user,
      bookmarked_at: bookmark.bookmarked_at |> Timex.to_unix()
    }
  end
end
