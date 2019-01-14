defmodule MockServerWeb.ServerView do
  use MockServerWeb, :view
  import Destructure

  alias MockServer.Servers.Server
  alias Ecto.Changeset

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
    details = Enum.reduce(changeset.errors, %{}, fn ({key, {msg, _opts}}, acc) ->
      Map.update(acc, key, [msg], &([msg] ++ &1))
    end)

    %{code: "0001", message: "Invalid Parameters", details: details}
  end

  def render("servers.json", d(%{servers})) when is_list(servers) do
    %{
      data: Enum.map(servers, &render("server.json", &1))
    }
  end

  def render("server_not_found.json", _assigns) do
    %{code: "0002", message: "Server not found"}
  end
end
