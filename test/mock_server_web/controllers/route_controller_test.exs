defmodule MockServerWeb.RouteControllerTest do
  use MockServerWeb.ConnCase, async: true
  import Destructure

  alias MockServer.TestSupport.ServersFactory

  describe "create" do
    test "create route returns the route created", d%{conn} do
      server = ServersFactory.create()
      route = %{
        method: "GET",
        path: "/some-route",
        description: "Test route",
        status_code: 200,
        response_type: "json",
        response_body: ~S({"hello": "world"})
      }

      body =
        conn
        |> post(server_route_path(conn, :create, server.id), route)
        |> json_response(201)

      assert body["id"]
      assert body["server_id"] == server.id
      assert %{
        "method" => "GET",
        "path" => "/some-route",
        "description" => "Test route",
        "status_code" => 200,
        "response_type" => "json",
        "response_body" => ~S({"hello": "world"})
      } = body
    end
  end
end
