defmodule MockServerWeb.PageController do
  use MockServerWeb, :controller

  def index(conn, params) do
    IO.puts("ppage yo")
    IO.inspect(conn)
    IO.inspect(params)
    render conn, "index.html"
  end
end
