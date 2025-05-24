defmodule Mix.Tasks.Rss do
  use Mix.Task

  @shortdoc "Get recently hatena bookmark entries"
  @requirements ["app.start"]

  def run(_) do
    MasudaStream.Workers.RSS.new(%{})
    |> Oban.insert!()
  end
end
