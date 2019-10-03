defmodule MasudaStreamWeb.PageController do
  use MasudaStreamWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
