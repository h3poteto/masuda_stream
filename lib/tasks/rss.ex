defmodule MasudaStream.Tasks.RSS do
  require Logger

  @hatena_domain "https://b.hatena.ne.jp"
  @anond_url  "https://anond.hatelabo.jp/"

  def fetch() do
    Logger.info("Fetching...")

    {:ok, pid} = Task.Supervisor.start_link()
    rss_url = "#{@hatena_domain}/entrylist?mode=rss&url=#{@anond_url}&sort=recent"
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(rss_url)
    {:ok, feed, _} = FeederEx.parse(body)

    feed.entries
    |> Enum.map(fn(entry) ->
      Task.Supervisor.start_child(pid, MasudaStream.Tasks.Anond, :get, [entry.link])
      Task.Supervisor.start_child(pid, MasudaStream.Tasks.Bookmark, :get, [entry.link])
    end)
  end
end
