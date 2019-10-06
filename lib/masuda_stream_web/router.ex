defmodule MasudaStreamWeb.Router do
  use MasudaStreamWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MasudaStreamWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/entries/:id", PageController, :index
    get "/bookmarks", PageController, :index
    get "/auth/login", PageController, :index

    get "/auth/:provider", AuthController, :new
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :callback
  end

  scope "/api", MasudaStreamWeb do

    scope "/masuda", Masuda, as: :masuda do
      pipe_through :api
      resources "/entries", EntriesController, only: [:index, :show] do
        get "/bookmarks", Entries.BookmarksController, :index
      end
    end
  end
end
