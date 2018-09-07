defmodule MockServerWeb.PageController do
  use MockServerWeb, :controller

  def index(conn, params) do
    render conn, "index.html"
  end
end
