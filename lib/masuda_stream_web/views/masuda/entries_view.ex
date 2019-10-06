defmodule MasudaStreamWeb.Masuda.EntriesView do
  use MasudaStreamWeb, :view
  use Timex
  alias MasudaStreamWeb.Masuda.EntriesView

  def render("index.json", %{entries: entries}) do
    %{entries: render_many(entries, EntriesView, "entry.json", as: :entry)}
  end

  def render("show.json", %{entry: entry}) do
    %{entry: render_one(entry, EntriesView, "entry_detail.json", as: :entry)}
  end
  
  def render("entry.json", %{entry: entry}) do
    %{
      id: entry.id,
      title: entry.title,
      summary: entry.summary,
      content: entry.content,
      link: entry.link,
      hatena_bookmarkcount: entry.hatena_bookmarkcount,
      posted_at: entry.posted_at |> Timex.to_unix()
    }
  end

  def render("entry_detail.json", %{entry: entry}) do
    %{
      id: entry.id,
      title: entry.title,
      summary: entry.summary,
      content: entry.content,
      anond_content_html: entry.anond.content_html,
      link: entry.link,
      hatena_bookmarkcount: entry.entry_detail.count,
      screenshot: entry.entry_detail.screenshot,
      posted_at: entry.posted_at |> Timex.to_unix()
    }
  end
end
