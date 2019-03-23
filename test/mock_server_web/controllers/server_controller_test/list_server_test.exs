defmodule MockServerWeb.ServerControllerTest.ListServerTest do
  use MockServerWeb.ConnCase
  alias MockServer.TestSupport.{ServerFactory, RouteFactory}
  alias MockServer.Assertions

  @moduletag :run_server_processes

  test "returns list of servers", d%{conn} do
    servers = ServerFactory.create_list(3)
    body =
      conn
      |> get(server_path(conn, :index))
      |> json_response(200)

    response_ids = Enum.map(body["data"], fn d -> d["id"] end)
    server_ids = Enum.map(servers, fn d -> d.id end)
    assert Assertions.matches_members?(response_ids, server_ids)
  end

  test "with_routes=true retrieves server routes", d%{conn} do
    server = ServerFactory.create()
    route = RouteFactory.create(%{path: "/test", server_id: server.id})
    body =
      conn
      |> get(server_path(conn, :index), with_routes: "true")
      |> json_response(200)

    returned_route =
      body["data"]
      |> Enum.at(0)
      |> Map.get("routes")
      |> Enum.at(0)

    assert returned_route
    assert returned_route["id"] == route.id
    assert returned_route["path"] == route.path
  end
end
