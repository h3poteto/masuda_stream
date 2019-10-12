defmodule MasudaStreamWeb.UserController do
  use MasudaStreamWeb, :controller
  plug MasudaStreamWeb.Plugs.UserAuthentication

  def index(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    conn
    |> render("index.json", user: user)
  end
end
