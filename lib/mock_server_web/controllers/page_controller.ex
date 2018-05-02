defmodule MockServerWeb.PageController do
  use MockServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
