defmodule MockServerWeb.PageController do
  use MockServerWeb, :controller

  def index(conn, _params) do
    IO.puts("ppage yo")
    render conn, "index.html"
  end
end
