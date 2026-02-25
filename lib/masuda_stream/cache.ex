defmodule MasudaStream.Cache do
  @moduledoc false
  @cache_name :api_cache

  def fetch(key, ttl_seconds, fun) do
    case Cachex.get(@cache_name, key) do
      {:ok, nil} ->
        value = fun.()
        Cachex.put(@cache_name, key, value, ttl: :timer.seconds(ttl_seconds))
        value

      {:ok, value} ->
        value
    end
  end

  def invalidate_entries do
    Cachex.clear(@cache_name)
  end

  def invalidate_entry(entry_id) do
    Cachex.del(@cache_name, "entry:#{entry_id}")
  end

  def invalidate_bookmarks(entry_id) do
    Cachex.del(@cache_name, "bookmarks:#{entry_id}")
  end
end
