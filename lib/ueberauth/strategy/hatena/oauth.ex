defmodule Ueberauth.Strategy.Hatena.OAuth do
  @moduledoc false

  @request_token_url "https://www.hatena.com/oauth/initiate"
  @access_token_url "https://www.hatena.com/oauth/token"
  @authorize_url "https://www.hatena.ne.jp/oauth/authorize"

  def request_token(params \\ [], opts \\ []) do
    client = client(opts)
    params = [{"oauth_callback", client.redirect_uri} | params]
    body = %{scope: client.scope}

    {consumer_key, consumer_secret, _} = client |> consumer()
    creds = OAuther.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret
    )

    # Hatena does not accept body params as scope.
    # We have to set scope in url query parameters.
    url = "#{@request_token_url}?#{URI.encode_query(body)}"

    {header, _params} =
      "post"
      |> OAuther.sign(url, params, creds)
      |> OAuther.header

    HTTPoison.post(url, URI.encode_query(body), [header])
    |> decode_response
  end

  def request_token!(params \\ [], opts \\ []) do
    case request_token(params, opts) do
      {:ok, token} -> token
      {:error, error} -> raise error
    end
  end

  def authorize_url!({token, _token_secret}, callback_url) do
    "#{@authorize_url}?oauth_token=#{token}&oauth_callback=#{callback_url}"
  end

  def access_token({token, token_secret}, verifier) do
    {consumer_key, consumer_secret, _} = client() |> consumer()
    creds = OAuther.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: token,
      token_secret: token_secret
    )
    {header, _params} =
      "post"
      |> OAuther.sign(@access_token_url, [{"oauth_verifier", verifier}], creds)
      |> OAuther.header

    HTTPoison.post(@access_token_url, [], [header])
    |> decode_response
  end

  def access_token!(access_token, verifier) do
    case access_token(access_token, verifier) do
      {:ok, token} -> token
      {:error, error} -> raise error
    end
  end

  def client(opts \\ []) do
    config = Application.get_env(:ueberauth, __MODULE__)

    []
    |> Keyword.merge(config)
    |> Keyword.merge(opts)
    |> Enum.into(%{})
  end

  def scope(client), do: client.scope

  def consumer(client), do: {client.consumer_key, client.consumer_secret, :hmac_sha1}

  defp decode_response({:ok, %{status_code: 200, body: body, headers: _}}) do
    params = params_decode(body)
    {:ok, params}
  end
  defp decode_response({:ok, %{status_code: status_code, body: body, headers: _}}) do
    {:error, "#{status_code}: #{body}"}
  end
  defp decode_response({:error, %{reason: reason}}) do
    {:error, "#{reason}"}
  end
  defp decode_response(error) do
    {:error, error}
  end

  def params_decode(resp) do
    resp
    |> String.split("&", trim: true)
    |> Enum.map(&String.split(&1, "="))
    |> Enum.map(&List.to_tuple/1)
    |> Enum.into(%{})
  end
end
