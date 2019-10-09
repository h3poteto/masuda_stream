defmodule MasudaStreamWeb.User.BookmarksController do
  use MasudaStreamWeb, :controller

  def show(conn, %{"url" => target_url} = _params) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        token: token, secret: secret}} = get_session(conn, :current_user_auth)

    case Hatena.APIClient.get_bookmark(target_url, token, secret) do
      {:ok, nil} ->
        conn
        |> send_resp(404, "Isn't bookmarked")
      {:ok, body} ->
        conn
        |> render("show.json", %{bookmark: body})
    end
  end

  def create(conn, %{"url" => target_url, "comment" => comment} = _params) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        token: token, secret: secret}} = get_session(conn, :current_user_auth)

    case Hatena.APIClient.add_bookmark(target_url, comment, token, secret) do
      {:ok, body} ->
        conn
        |> render("show.json", %{bookmark: body})
    end
  end
end
