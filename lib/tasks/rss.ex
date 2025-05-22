defmodule MasudaStream.Tasks.RSS do
  use Timex
  require Logger
  alias MasudaStream.Hatena.Entry
  alias MasudaStream.Repo

  @hatena_domain "https://b.hatena.ne.jp"
  @anond_url "https://anond.hatelabo.jp"

  def rss do
    fetch()
  rescue
    exception ->
      Rollbax.report(:error, exception, __STACKTRACE__)
  end

  def fetch() do
    get()
    |> Enum.map(fn item ->
      item |> parse()
    end)
    |> Enum.filter(fn item ->
      anond_page?(item.link)
    end)
    |> Enum.map(fn item ->
      item |> save_entry()
    end)
    |> fetch_anonds()
    |> fetch_bookmarks()
  end

  def get() do
    rss_url = "#{@hatena_domain}/site/#{@anond_url}/?mode=rss&sort=recent"
    Logger.info("Fetching #{rss_url} ...")
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(rss_url)

    body
    |> Quinn.parse()
    |> Quinn.find(:item)
  end

  def parse(item) do
    %{
      title: parse_title(item),
      summary: parse_summary(item),
      content: parse_content(item),
      link: parse_link(item),
      hatena_bookmarkcount: parse_hatena_bookmarkcount(item),
      posted_at: parse_posted_at(item)
    }
  end

  defp parse_title(item) do
    [%{attr: _, name: :title, value: [title]}] = item |> Quinn.find(:title)
    title
  end

  defp parse_summary(item) do
    case item |> Quinn.find(:description) do
      [%{attr: _, name: :description, value: [summary]}] -> summary
      _ -> nil
    end
  end

  defp parse_content(item) do
    [%{attr: _, name: :"content:encoded", value: [content]}] =
      item |> Quinn.find(:"content:encoded")

    content
  end

  defp parse_link(item) do
    [%{attr: _, name: :link, value: [link]}] = item |> Quinn.find(:link)
    link
  end

  defp parse_hatena_bookmarkcount(item) do
    [%{attr: _, name: :"hatena:bookmarkcount", value: [hatena_bookmarkcount]}] =
      item |> Quinn.find(:"hatena:bookmarkcount")

    hatena_bookmarkcount |> String.to_integer(10)
  end

  defp parse_posted_at(item) do
    # Timezone in RSS is UTC. The format is "2019-10-05T13:46:58Z".
    [%{attr: _, name: :"dc:date", value: [posted_at]}] = item |> Quinn.find(:"dc:date")

    posted_at
    |> Timex.parse!("{ISO:Extended:Z}")
  end

  defp anond_page?(link) do
    # Sometimes, keyword page is included in the RSS.
    # e.g. https://anond.hatelabo.jp/search?word=%E3%82%B5%E3%82%AC%E3%83%83%E3%83%88%E3%80%8C%E6%84%9B%E3%81%8C%E3%83%BC%E3%80%81%E6%84%9B%E3%81%8C%E3%83%BC%E3%80%81%E6%84%9B%E3%81%8C%E3%81%82%E3%81%A3%E3%81%9F%E3%81%AE%E3%81%8B%E3%80%8D&search=%E6%A4%9C%E7%B4%A2
    Regex.match?(~r/#{@anond_url}\/\d+/, link)
  end

  defp save_entry(%{
         title: title,
         summary: summary,
         link: link,
         content: content,
         hatena_bookmarkcount: hatena_bookmarkcount,
         posted_at: posted_at
       }) do
    case Repo.get_by(Entry, link: link) do
      nil -> %Entry{link: link}
      entry -> entry
    end
    |> Entry.changeset(%{
      "title" => title,
      "summary" => summary,
      "content" => content,
      "link" => link,
      "hatena_bookmarkcount" => hatena_bookmarkcount,
      "posted_at" => posted_at
    })
    |> Repo.insert_or_update!()
  end

  def fetch_anonds(entries) do
    {:ok, pid} = Task.Supervisor.start_link()

    _ =
      entries
      |> Enum.map(fn entry ->
        Task.Supervisor.async_nolink(pid, MasudaStream.Tasks.Anond, :fetch, [entry])
      end)
      |> Enum.map(fn task ->
        Task.await(task, 60_000)
      end)

    entries
  end

  def fetch_bookmarks(entries) do
    {:ok, pid} = Task.Supervisor.start_link()

    entries
    |> Enum.map(fn entry ->
      Task.Supervisor.async_nolink(pid, MasudaStream.Tasks.Bookmark, :fetch, [entry])
    end)
    |> Enum.map(fn task ->
      Task.await(task, 60_000)
    end)
  end
end
