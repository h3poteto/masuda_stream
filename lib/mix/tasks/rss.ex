defmodule Mix.Tasks.Rss do
  use Mix.Task
  alias MasudaStream.Tasks.RSS

  @shortdoc "Get recently hatena bookmark entries"
  @requirements ["app.start"]

  def run(_) do
    RSS.rss()
  end
end
