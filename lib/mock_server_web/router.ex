defmodule MockServerWeb.Router do
  use MockServerWeb, :router

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

  pipeline :any do
    plug :accepts, ["html", "json"]
  end

  scope "/access", MockServerWeb, as: :access do
    pipe_through :any

    get "/*path", ServerController, :access
    post "/*path", ServerController, :access
    put "/*path", ServerController, :access
    patch "/*path", ServerController, :access
    delete "/*path", ServerController, :access
  end

  scope "/api", MockServerWeb do
    pipe_through :api
    resources "/servers", ServerController, only: [:create, :show, :index] do
      resources "/routes", RouteController, only: [:create, :index]
      post "/start", ServerController, :start, as: :start
    end
  end

  scope "/", MockServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
