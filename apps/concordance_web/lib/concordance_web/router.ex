defmodule ConcordanceWeb.Router do
  use ConcordanceWeb, :router

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

  scope "/", ConcordanceWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/events/:id", EventController, :show
    get "/report", ConcordanceController, :show
    post "/add", ConcordanceController, :add
  end

  # Other scopes may use custom stacks.
  # scope "/api", ConcordanceWeb do
  #   pipe_through :api
  # end
end
