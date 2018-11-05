defmodule MockServer.ServerControllerTest.StopTest do
  use MockServerWeb.ConnCase
  alias MockServer.TestSupport.ServerFactory

  @moduletag :run_server_processes

  test "stopping non-existent server returns not found", d%{conn} do
    non_existing_id = "51f41bf1-0b6e-4375-b5e7-4f6546f63212"
    res = post(conn, server_stop_path(conn, :stop, non_existing_id))
    assert res.status == 404
  end

  test "stopping a server will return the server", d%{conn} do
    server = ServerFactory.create()
    body =
      conn
      |> post(server_stop_path(conn, :stop, server.id))
      |> json_response(200)

    assert body == %{
      "description" => server.description,
      "id" => server.id,
      "isRunning" => server.running?,
      "name" => server.name,
      "path" => server.path
    }
  end
end
