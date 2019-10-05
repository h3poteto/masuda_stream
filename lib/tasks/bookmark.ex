defmodule MasudaStream.Tasks.Bookmark do
  require Logger
  alias MasudaStream.Repo

  @bookmark_url "http://b.hatena.ne.jp/entry/jsonlite/?url="

  def get(%MasudaStream.Hatena.Entry{} = entry) do
    response = fetch(entry.link)
    response
    |> save_detail(entry)
    |> save_bookmarks(response)
  end

  def fetch(url) do
    Logger.info("Fetching bookmark: #{url}")
    url = "#{@bookmark_url}#{url}"
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    {:ok, response} = body |> JSON.decode
    response
  end


  defp save_detail(%{"eid" => eid, "count" => count, "url" => url, "title" => title, "screenshot" => screenshot}, %MasudaStream.Hatena.Entry{} = entry) do
    case Repo.get_by(MasudaStream.Hatena.EntryDetail, entry_id: entry.id) do
      nil -> %MasudaStream.Hatena.EntryDetail{entry_id: entry.id}
      detail -> detail
    end
    |> MasudaStream.Hatena.EntryDetail.changeset(
      %{
        "eid" => eid,
        "count" => count,
        "screenshot" => screenshot,
        "title" => title,
        "url" => url
      }
    )
    |> Repo.insert_or_update!()
  end

  defp save_bookmarks(%MasudaStream.Hatena.EntryDetail{} = detail, %{"bookmarks" => bookmarks}) do
    bookmarks
    |> Enum.map(fn(%{"comment" => comment, "timestamp" => timestamp, "user" => user}) ->
      # This timestamp is JST. The format is "2019/10/05 22:46".
      tz_timestamp = timestamp
      |> Timex.parse!("%Y/%m/%d %H:%M", :strftime)
      |> Timex.to_datetime("Asia/Tokyo")

      case Repo.get_by(MasudaStream.Hatena.EntryBookmark, [entry_detail_id: detail.id, user: user]) do
        nil -> %MasudaStream.Hatena.EntryBookmark{entry_detail_id: detail.id, user: user}
        bookmark -> bookmark
      end
      |> MasudaStream.Hatena.EntryBookmark.changeset(
        %{
          "comment" => comment,
          "bookmarked_at" => tz_timestamp
        }
      )
      |> Repo.insert_or_update!()
    end)
  end
end
