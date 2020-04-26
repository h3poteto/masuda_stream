defmodule Mix.Tasks.Rss do
  @moduledoc false
  use Mix.Task
  alias MasudaStream.Tasks.RSS

  @shortdoc "Get recently hatena bookmark entries"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:masuda_stream)
    RSS.fetch()
  end
end
