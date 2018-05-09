defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view
  import Destructure

  def render("server.json", d(%{server})) do
    Map.take(server, ~w(id name path description)a)
  end

  def render("servers.json", d(%{servers})) when is_list(servers) do
    %{
      data: Enum.map(servers, &render("server.json", %{server: &1}))
    }
  end
end
