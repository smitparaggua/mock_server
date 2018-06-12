defmodule MockServer.TestSupport.ServersFactory do

  alias MockServer.Servers.Server
  alias MockServer.Servers

  @default_route_attrs %{
    name: "Sample Server",
    path: "/server/sample",
    description: "A Sample Server"
  }

  def create(custom_attributes \\ %{}) do
    {:ok, server} =
      @default_route_attrs
      |> Map.merge(custom_attributes)
      |> Servers.create()

    server
  end

  def build(custom_attributes \\ %{}) do
    attributes = Map.merge(@default_route_attrs, custom_attributes)
    struct(Server, attributes)
  end
end
