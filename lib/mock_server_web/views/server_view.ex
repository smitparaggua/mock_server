defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view

  def render("server.json", server) do
    Map.take(server, ["id", "name", "path", "description"])
  end
end
