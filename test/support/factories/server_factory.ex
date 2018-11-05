defmodule MockServer.TestSupport.ServerFactory do

  alias MockServer.Servers.Server
  alias MockServer.TestSupport.RouteFactory
  alias MockServer.Repo

  def create(custom_attributes \\ %{}) do
    generate_default()
    |> Map.merge(custom_attributes)
    |> (&Server.changeset(%Server{}, &1)).()
    |> Repo.insert!()
  end

  def create_list(count) do
    Enum.map(1..count, fn _x -> create() end)
  end

  def create_with_route(custom_attributes \\ %{}, route_attributes \\ %{}) do
    server = create(custom_attributes)
    route_attributes
    |> Map.merge(%{server_id: server.id})
    |> RouteFactory.create()

    Map.merge(server, %{routes: [server]})
  end

  def build(custom_attributes \\ %{}) do
    attributes = Map.merge(generate_default(), custom_attributes)
    struct(Server, attributes)
  end

  defp generate_default() do
    %{
      name: ExRandomString.generate(),
      path: "/#{ExRandomString.generate()}",
      description: "A Sample Server"
    }
  end
end
