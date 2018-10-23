defmodule MockServer.TestSupport.RouteFactory do

  alias MockServer.Servers.Route
  alias MockServer.Repo

  def create(custom_attributes \\ %{}) do
    attributes = Map.merge(generate_default(), custom_attributes)
    {:ok, route} =
      %Route{server_id: attributes.server_id}
      |> Route.changeset(attributes)
      |> Repo.insert()

    route
  end

  def build(custom_attributes \\ %{}) do
    attributes = Map.merge(generate_default(), custom_attributes)
    struct(Route, attributes)
  end

  defp generate_default() do
    %{
      method: "GET",
      path: "/#{ExRandomString.generate()}",
      status_code: "200",
      response_type: "text/plain",
      response_body: "hello, world"
    }
  end
end
