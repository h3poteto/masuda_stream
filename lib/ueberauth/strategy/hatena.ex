defmodule Ueberauth.Strategy.Hatena do
  @moduledoc false

  use Ueberauth.Strategy, uid_field: :url_name

  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra
  alias Ueberauth.Auth.Info
  alias Ueberauth.Strategy.Hatena

  def handle_request!(conn) do
    %{"oauth_token" => token, "oauth_token_secret" => token_secret} = Hatena.OAuth.request_token!([], [redirect_uri: callback_url(conn)])
    # Hatena returns token with URI encoded, so we have to save decoded token and secret.
    raw_token = URI.decode(token)
    raw_token_secret = URI.decode(token_secret)

    conn
    |> put_session(:hatena_token, {raw_token, raw_token_secret})
    |> redirect!(Hatena.OAuth.authorize_url!({token, token_secret}, callback_url(conn)))
  end

  def handle_callback!(%Plug.Conn{params: %{"oauth_verifier" => oauth_verifier}} = conn) do
    token = get_session(conn, :hatena_token)
    case Hatena.OAuth.access_token(token, oauth_verifier) do
      {:ok, %{"oauth_token" => oauth_token, "oauth_token_secret" => oauth_token_secret}} ->
        # Hatena returns token with URI encoded, so we have to save decoded token and secret.
        fetch_user(conn, URI.decode(oauth_token), URI.decode(oauth_token_secret))
      {:error, error} -> set_errors!(conn, [error(error.code, error.reason)])
    end
  end

  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  def handle_cleanup!(conn) do
    conn
    |> put_private(:hatena_user, nil)
    |> put_session(:hatena_token, nil)
  end

  def uid(conn) do
    uid_field =
      conn
      |> option(:uid_field)
      |> to_string

    conn.private.hatena_user[uid_field]
  end

  def credentials(conn) do
    {token, secret} = conn.private.hatena_token

    %Credentials{token: token, secret: secret}
  end

  def info(conn) do
    user = conn.private.hatena_user

    %Info{
      name: user["url_name"],
      nickname: user["display_name"]
    }
  end

  def extra(conn) do
    {token, _secret} = get_session(conn, :hatena_token)

    %Extra{
      raw_info: %{
        token: token,
        user: conn.private.hatena_user
      }
    }
  end

  defp fetch_user(conn, token, token_secret) do
    case Hatena.Client.get("http://n.hatena.com/applications/my.json", token, token_secret) do
      {:ok, %{status_code: 401, body: _, headers: _}} ->
        set_errors!(conn, [error("token", "unauthorized")])
      {:ok, %{status_code: status_code, body: body, headers: _}} when status_code in 200..399 ->
        body = Ueberauth.json_library().decode!(body)

        conn
        |> put_private(:hatena_token, {token, token_secret})
        |> put_private(:hatena_user, body)
      {:ok, %{status_code: _, body: body, headers: _}} ->
        body = Ueberauth.json_library().decode!(body)
        error = List.first(body["errors"])
        set_errors!(conn, [error("token", error["message"])])
    end
  end

  defp option(conn, key) do
    default = Keyword.get(default_options(), key)

    conn
    |> options
    |> Keyword.get(key, default)
  end
end
