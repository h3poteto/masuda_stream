defmodule MasudaStreamWeb.Router do
  use MasudaStreamWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/", MasudaStreamWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/entries/:id", PageController, :index
    get "/auth/login", PageController, :index
    get "/about", PageController, :index

    get "/auth/:provider", AuthController, :new
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :callback
  end

  scope "/api", MasudaStreamWeb do
    pipe_through :api

    scope "/masuda", Masuda, as: :masuda do
      resources "/entries", EntriesController, only: [:index, :show] do
        get "/bookmarks", Entries.BookmarksController, :index
      end
    end

    scope "/user" do
      get "/my", UserController, :index
      delete "/logout", UserController, :delete
      get "/bookmark", User.BookmarksController, :show
      post "/bookmark", User.BookmarksController, :create
    end
  end

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{}}) do
    conn
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    params =
      case conn.params do
        %Plug.Conn.Unfetched{aspect: :params} -> "unfetched"
        other -> other
      end

    occurrence_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => List.to_string(:inet.ntoa(conn.remote_ip)),
        "headers" => Enum.into(conn.req_headers, %{}),
        "method" => conn.method,
        "params" => params
      }
    }

    Rollbax.report(kind, reason, stacktrace, _custom_data = %{}, occurrence_data)
  end
end
