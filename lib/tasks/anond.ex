defmodule MasudaStream.Tasks.Anond do
  require Logger
  alias MasudaStream.Repo

  @keyword_host "https://anond.hatelabo.jp"

  def get(%MasudaStream.Hatena.Entry{} = entry) do
    fetch(entry.link)
    |> save_anond(entry)
  end

  def fetch(url) do
    Logger.info("Fetching anond: #{url}")
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)

    body
    |> parse
  end

  defp parse(body) do
    body
    |> Floki.find("div.section")
    |> Enum.map(fn element -> children(element) end)
    |> Enum.flat_map(fn element -> element end)
    |> Enum.chunk_by(fn element ->
      title_ad?(element) || rectangle?(element) || share_button?(element)
    end)
    |> only_body()
    |> replace_keyword_link()
    |> Floki.raw_html()
  end

  defp replace_keyword_link(body) do
    body
    |> Floki.traverse_and_update(fn element ->
      case element do
        {"a", [{"class", "keyword"}, {"href", link}], child} ->
          {"a", [{"class", "keyword"}, {"href", absolute_link(link)}], child}

        el ->
          el
      end
    end)
  end

  defp absolute_link(path) do
    "#{@keyword_host}#{path}"
  end

  defp children({"div", _class, children}) do
    children
  end

  defp title_ad?(element) do
    element
    |> Floki.attribute("id")
    |> Enum.any?(fn id -> id == "title-below-ad" || id == "title-below-text-ad" end)
  end

  defp rectangle?(element) do
    element
    |> Floki.attribute("id")
    |> Enum.any?(fn id -> id == "rectangle-middle" end)
  end

  defp share_button?(element) do
    element
    |> Floki.attribute("class")
    |> Enum.any?(fn class -> class == "share-button" end)
  end

  defp only_body([_, _start, body, _end, _]) do
    body
  end

  defp only_body(struct) do
    # Sometimes the entry was deleted, so we can not get entry from anond.
    Logger.error("could not parse body: #{inspect(struct)}")
    []
  end

  defp save_anond(content_html, %MasudaStream.Hatena.Entry{} = entry) do
    case Repo.get_by(MasudaStream.Anond, entry_id: entry.id) do
      nil -> %MasudaStream.Anond{entry_id: entry.id}
      anond -> anond
    end
    |> MasudaStream.Anond.changeset(%{
      "content_html" => content_html
    })
    |> Repo.insert_or_update!()
  end
end
