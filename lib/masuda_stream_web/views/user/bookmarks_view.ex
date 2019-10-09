defmodule MasudaStreamWeb.User.BookmarksView do
  use MasudaStreamWeb, :view

  def render("show.json", %{bookmark: bookmark}) do
    %{
      comment: bookmark["comment"],
      created_datetime: bookmark["created_datetime"],
      user: bookmark["user"]
    }
  end
end
