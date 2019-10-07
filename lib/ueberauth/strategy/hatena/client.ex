defmodule Ueberauth.Strategy.Hatena.Client do
  @moduledoc false

  alias Ueberauth.Strategy.Hatena.OAuth

  def get(url, access_token, access_token_secret), do: get(url, [], access_token, access_token_secret)
  def get(url, params, access_token, access_token_secret) do
    {consumer_key, consumer_secret, _} = OAuth.client() |> OAuth.consumer()
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
