defmodule MockServer.Servers.RunningServerTest do
  use ExUnit.Case, async: true
  alias MockServer.Servers.{RunningServer, Server, Route}

  setup do
    server = %Server{
      name: "Server 1",
      path: "/server",
      routes: []
    }

    {:ok, %{server: server}}
  end

  describe "access_path" do
    test "returns a response based on the configured route", %{server: server} do
      routes = [
        %Route{
          method: "GET",
          path: "/hello",
          status_code: 200,
          response_type: "application/json",
          response_body: ~S({"hello": "world"})
        },

        %Route{
          method: "POST",
          path: "/hello-sir",
          status_code: 200,
          response_type: "application/json",
          response_body: ~S({"hello": "sir"})
        }
      ]

      server = Map.put(server, :routes, routes)
      {:ok, server_pid} = start_supervised({RunningServer, server})
      assert RunningServer.access_path(server_pid, "POST", "/hello-sir") == %{
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "sir"})
      }
    end

    test "when route does not exist", %{server: server} do
      {:ok, server_pid} = start_supervised({RunningServer, server})
      assert RunningServer.access_path(server_pid, "POST", "/hello-sir") == %{
        status_code: 404,
        response_type: "text/plain",
        response_body: "Not found"
      }
    end

    test "ignores query params on path resolution", %{server: server} do
      routes = [
        %Route{
          method: "GET",
          path: "/hello",
          status_code: 200,
          response_type: "application/json",
          response_body: ~S({"hello": "world"})
        },
      ]

      server = Map.put(server, :routes, routes)
      {:ok, server_pid} = start_supervised({RunningServer, server})
      assert RunningServer.access_path(server_pid, "GET", "/hello?query=param") == %{
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }
    end
  end
end
