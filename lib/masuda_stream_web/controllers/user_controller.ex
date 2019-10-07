defmodule MasudaStreamWeb.UserController do
  use MasudaStreamWeb, :controller

  def index(conn, _params) do
    auth = get_session(conn, :current_user_auth)
    conn
    |> render("index.json", auth: auth)
  end
end
