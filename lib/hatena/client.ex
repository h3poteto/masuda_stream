defmodule Hatena.APIClient do
  @moduledoc false

  @rest_url "https://bookmark.hatenaapis.com/rest/1"

  def get_bookmark(target_url, oauth_token, oauth_token_secret) do
    url = "#{@rest_url}/my/bookmark"

    case get(url, [{"url", target_url}], oauth_token, oauth_token_secret) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:ok, nil}
      {:ok, %HTTPoison.Response{status_code: _, body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def get(url, access_token, access_token_secret), do: get(url, [], access_token, access_token_secret)
  def get(url, params, access_token, access_token_secret) do
    consumer_key = Application.get_env(:ueberauth, Ueberauth.Strategy.Hatena.OAuth)[:consumer_key]
    consumer_secret = Application.get_env(:ueberauth, Ueberauth.Strategy.Hatena.OAuth)[:consumer_secret]
    creds = OAuther.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: access_token,
      token_secret: access_token_secret
    )

    {header, query_params} =
      "get"
      |> OAuther.sign(url, params, creds)
      |> OAuther.header

    HTTPoison.get(url, [header], params: query_params)
  end
end
