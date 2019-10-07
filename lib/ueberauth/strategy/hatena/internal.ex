defmodule Ueberauth.Strategy.Hatena.OAuth.Internal do
  @moduledoc """
  A layer to handle OAuth signing, etc.
  """

  def get(url, extraparams, {consumer_key, consumer_secret, _}, token \\ "", token_secret \\ "") do
    creds = OAuther.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: token,
      token_secret: token_secret
    )
    {header, params} =
      "get"
      |> OAuther.sign(url, extraparams, creds)
      |> OAuther.header

    HTTPoison.get(url, [header], params: params)
  end

  def token(params) do
    params["oauth_token"]
  end

  def token_secret(params) do
    params["oauth_token_secret"]
  end
end
