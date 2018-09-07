defmodule MockServerWeb.ServerControllerTest.RunningServer do
  use MockServerWeb.ConnCase
  import Destructure
  alias MockServer.Servers
  alias MockServer.Servers.{RunningServerSupervisor, RunningRegistry}

  describe "start" do
    setup do
      start_supervised!(RunningRegistry)
      start_supervised!(
        {DynamicSupervisor, name: RunningServerSupervisor, strategy: :one_for_one}
      )
      :ok
    end

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
  end

  describe "access" do
    setup do
      start_supervised!(RunningRegistry)
      start_supervised!(
        {DynamicSupervisor, name: RunningServerSupervisor, strategy: :one_for_one}
      )

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
      response = get(conn, access_server_path(conn, :access, ["server", "path"]))
      assert response.status == 200
      assert response.resp_body == ~s({"hello": "world"})

      content_type = Enum.find_value(response.resp_headers, fn header ->
        case header do
          {"content-type", value} -> value
          _ -> false
        end
      end)

      assert content_type == "application/json; charset=utf-8"
    end
  end
end
