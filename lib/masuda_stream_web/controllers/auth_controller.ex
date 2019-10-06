defmodule MasudaStreamWeb.AuthController do
  use MasudaStreamWeb, :controller
  alias Ueberauth.Strategy.Helpers
  plug Ueberauth

  def new(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: MasudaStreamWeb.Router.Helpers.auth_path(conn, :new, "login"))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    conn
    |> put_private(:hatena_session, auth)
    |> redirect(to: MasudaStreamWeb.Router.Helpers.page_path(conn, :index))
  end
end
