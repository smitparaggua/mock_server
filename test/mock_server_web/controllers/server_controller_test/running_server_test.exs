defmodule MockServerWeb.ServerControllerTest.RunningServerTest do
  use MockServerWeb.ConnCase
  alias MockServer.Servers
  alias MockServer.TestSupport.ServerFactory

  @moduletag :run_server_processes

  describe "start" do
    test "returns not found when server does not exist", d%{conn} do
      non_existing_id = "51f41bf1-0b6e-4375-b5e7-4f6546f63212"
      response = post(conn, server_start_path(conn, :start, non_existing_id))
      assert response.status == 404
    end

    test "returns success when starting stopped server", d%{conn} do
      {:ok, server} = Servers.create(%{name: "Server", path: "/server"})
      response = post(conn, server_start_path(conn, :start, server.id))
      assert response.status == 200
    end

    test "tolerates calling start on running server", d%{conn} do
      {:ok, server} = Servers.create(%{name: "Server", path: "/server"})
      response = post(conn, server_start_path(conn, :start, server.id))
      assert response.status == 200
      response = post(conn, server_start_path(conn, :start, server.id))
      assert response.status == 200
    end

    test "makes server accessible", d%{conn} do
      route_params = %{
        method: "GET",
        path: "/hello",
        status_code: "200",
        response_type: "text/plain",
        response_body: "hello, world"
      }

      server = ServerFactory.create_with_route(%{}, route_params)
      post(conn, server_start_path(conn, :start, server.id))
      response = get(conn, "/access#{server.path}/hello")
      assert response.status == 200
      assert response.resp_body == "hello, world"
    end
  end

  describe "access" do
    setup do
      route_attrs = %{
        method: "GET",
        path: "/path",
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }

      {:ok, server} = Servers.create(%{name: "Server", path: "/server"})
      Servers.add_route(server.id, route_attrs)
      Servers.run(server)
      {:ok, d%{server}}
    end

    test "returns configured response of the server", d%{conn} do
      conn = get(conn, access_server_path(conn, :access, ["server", "path"]))
      assert conn.status == 200
      assert conn.resp_body == ~s({"hello": "world"})
      assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
    end

    test "returns server not found when server path does not exist", d%{conn} do
      conn = get(conn, access_server_path(conn, :access, ["not-server", "path"]))
      assert conn.status == 404
      assert conn.resp_body == "Server not found"
      assert get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
    end

    test "returns error when server accessed is not running" do
    end
  end

  describe "deleting a server" do
    setup do
      server = ServerFactory.create()
      {:ok, d%{server}}
    end

    test "deletes the server if server exists", d%{conn, server} do
      delete(conn, server_path(conn, :delete, server.id))
      response = get(conn, server_path(conn, :show, server.id))
      assert response.status == 404
    end

    test "returns not found when server does not exist", d%{conn} do
      fake_id = "f83dc132-f8b7-415f-b8c9-da59c7fe50cd"
      body =
        conn
        |> delete(server_path(conn, :delete, fake_id))
        |> json_response(404)

      assert body == %{"code" => "0002", "message" => "Server not found"}
    end

    test "returns the deleted server", d%{conn, server} do
      body =
        conn
        |> delete(server_path(conn, :delete, server.id))
        |> json_response(200)

      assert body["id"] == server.id
    end
  end
end
