defmodule MockServerWeb.ServerControllerTest.ListServerTest do
  use MockServerWeb.ConnCase
  alias MockServer.TestSupport.ServerFactory
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
end
