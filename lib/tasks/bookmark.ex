defmodule MasudaStream.Tasks.Bookmark do
  require Logger
  @bookmark_url "http://b.hatena.ne.jp/entry/jsonlite/?url="

  def get(url) do
    fetch(url)
    # TODO: save
  end

  def fetch(url) do
    Logger.info("Fetching bookmark: #{url}")
    url = "#{@bookmark_url}#{url}"
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    {:ok, response} = body |> JSON.decode
    response
  end

end
