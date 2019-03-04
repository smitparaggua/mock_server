defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view
  import Destructure

  alias MockServer.Servers.Server
  alias Ecto.Changeset
  alias MockServerWeb.ErrorView

  def render("server.json", %Server{} = server) do
    Map.take(server, ~w(id name path description)a)
    %{
      id: server.id,
      name: server.name,
      path: server.path,
      description: server.description,
      isRunning: server.running?
    }
  end

  def render("server.json", %Changeset{} = changeset) do
    ErrorView.render("invalid_params", d%{changeset})
  end

  def render("servers.json", d(%{servers})) when is_list(servers) do
    %{
      data: Enum.map(servers, &render("server.json", &1))
    }
  end

  def render("server_not_found.json", _assigns) do
    %{code: "SRV002", message: "Server not found"}
  end
end
