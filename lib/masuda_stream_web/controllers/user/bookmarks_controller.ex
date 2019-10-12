defmodule MasudaStreamWeb.User.BookmarksController do
  use MasudaStreamWeb, :controller
  plug MasudaStreamWeb.Plugs.UserAuthentication

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"url" => target_url} = _params) do
    case Hatena.APIClient.get_bookmark(target_url, user.token, user.token_secret) do
      {:ok, nil} ->
        conn
        |> send_resp(404, "Isn't bookmarked")

      {:ok, body} ->
        conn
        |> render("show.json", %{bookmark: body})
    end
  end

  def create(
        %Plug.Conn{assigns: %{current_user: user}} = conn,
        %{"url" => target_url, "comment" => comment} = _params
      ) do
    case Hatena.APIClient.add_bookmark(target_url, comment, user.token, user.token_secret) do
      {:ok, body} ->
        conn
        |> render("show.json", %{bookmark: body})
    end
  end
end
