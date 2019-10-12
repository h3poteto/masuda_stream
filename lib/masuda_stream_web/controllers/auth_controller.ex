defmodule MasudaStreamWeb.AuthController do
  @moduledoc false
  use MasudaStreamWeb, :controller
  alias Ueberauth.Strategy.Helpers
  alias MasudaStream.Repo
  alias MasudaStream.User
  plug Ueberauth

  def new(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: MasudaStreamWeb.Router.Helpers.auth_path(conn, :new, "login"))
  end

  def callback(
        %{
          assigns: %{
            ueberauth_auth: %Ueberauth.Auth{
              credentials: %Ueberauth.Auth.Credentials{token: token, secret: secret},
              info: %Ueberauth.Auth.Info{name: name, nickname: nickname},
              extra: %Ueberauth.Auth.Extra{
                raw_info: %{
                  user: %{"profile_image_url" => icon}
                }
              }
            }
          }
        } = conn,
        _params
      ) do
    case Repo.get_by(User, identifier: name) do
      nil -> %User{identifier: name}
      user -> user
    end
    |> User.changeset(%{
      "display_name" => nickname,
      "identifier" => name,
      "token" => token,
      "token_secret" => secret,
      "icon" => icon
    })
    |> Repo.insert_or_update!()

    conn
    |> put_session(:current_user_name, name)
    |> redirect(to: MasudaStreamWeb.Router.Helpers.page_path(conn, :index))
  end
end
