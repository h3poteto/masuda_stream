defmodule MasudaStreamWeb.Plugs.UserAuthentication do
  import Plug.Conn
  import Phoenix.Controller
  alias MasudaStream.User
  alias MasudaStream.Repo

  def init(default), do: default

  def call(conn, _default) do
    case current_user_auth(conn) do
      nil ->
        conn
        |> put_status(401)
        |> render(MasudaStreamWeb.ErrorView, "error.json", %{status: 401, message: "Unauthorized"})
        |> halt

      user ->
        conn
        |> assign(:current_user, user)
    end
  end

  def current_user_auth(conn) do
    with identifier when identifier != nil <- get_session(conn, :current_user_name),
         %User{} = user when user != nil <- Repo.get_by(User, identifier: identifier) do
      user
    else
      nil -> nil
    end
  end
end
