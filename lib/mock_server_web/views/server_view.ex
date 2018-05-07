defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view
  import Destructure

  def render("server.json", d(%{server})) do
    Map.take(server, ~w(id name path description)a)
  end
end
