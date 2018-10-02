defmodule MockServer.TestSupport.ServersFactory do

  alias MockServer.Servers.Server
  alias MockServer.Servers

  def create(custom_attributes \\ %{}) do
    {:ok, server} =
      generate_default()
      |> Map.merge(custom_attributes)
      |> Servers.create()

    server
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
