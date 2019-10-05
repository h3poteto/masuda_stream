defmodule MasudaStream.Tasks.Anond do
  require Logger

  def get(url) do
    fetch(url)
    # TODO: save
  end

  def fetch(url) do
    Logger.info("Fetching anond: #{url}")
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    body
    |> parse
  end

  defp parse(body) do
    # TODO: はてなキーワードへのリンクを相対パスから絶対URLに変更しておく必要がある
    body
    |> Floki.find("div.section")
    |> Enum.map(fn(element) -> children(element) end)
    |> Enum.flat_map(fn(element) -> element end)
    |> Enum.chunk_by(fn(element) ->
      title_ad?(element) || rectangle?(element) || share_button?(element)
    end)
    |> only_body
    |> Floki.raw_html
  end

  defp children({"div", _class, children}) do
    children
  end

  defp title_ad?(element) do
    element
    |> Floki.attribute("id")
    |> Enum.any?(fn(id) -> id == "title-below-ad" || id == "title-below-text-ad" end)
  end

  defp rectangle?(element) do
    element
    |> Floki.attribute("id")
    |> Enum.any?(fn(id) -> id == "rectangle-middle" end)
  end

  defp share_button?(element) do
    element
    |> Floki.attribute("class")
    |> Enum.any?(fn(class) -> class == "share-button" end)
  end

  defp only_body([_, _start, body, _end, _]) do
    body
  end
end
