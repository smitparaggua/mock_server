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

  scope "/api", MockServerWeb do
    pipe_through :api
    resources "/servers", ServerController, only: [:create, :show, :index]
  end

  scope "/", MockServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
