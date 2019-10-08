defmodule MockServer.Servers.RunningServerTest do
  use ExUnit.Case, async: true
  alias MockServer.Servers.{RunningServer, Server, Route}

  setup do
    server = %Server{
      name: "Server 1",
      path: "/server",
      routes: [
        %Route{
          method: "GET",
          path: "/hello",
          status_code: 200,
          response_type: "application/json",
          response_body: ~S({"hello": "world"})
        }
      ]
    }

    {:ok, server_pid} = start_supervised({RunningServer, server}, id: :default_server)
    {:ok, %{server: server, server_pid: server_pid}}
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

    test "when route does not exist", %{server_pid: server_pid} do
      assert RunningServer.access_path(server_pid, "POST", "/hello-sir") == %{
        status_code: 404,
        response_type: "text/plain",
        response_body: "Not found"
      }
    end

    test "ignores query params on path resolution", %{server_pid: server_pid} do
      assert RunningServer.access_path(server_pid, "GET", "/hello?query=param") == %{
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }
    end

    test "supports delaying response", %{server: server} do
      routes = [
        %Route{
          method: "GET",
          path: "/delayed-hello",
          status_code: 200,
          response_type: "application/json",
          response_body: ~S({"hello": "world"}),
          response_delay_seconds: 1
        }
      ]

      server = Map.put(server, :routes, routes)
      {:ok, server_pid} = start_supervised({RunningServer, server})
      start_time = DateTime.utc_now()
      result = RunningServer.access_path(server_pid, "GET", "/delayed-hello")
      end_time = DateTime.utc_now()
      assert DateTime.diff(end_time, start_time, :millisecond) >= 1000
      assert result == %{
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }
    end

    test "logs requests to the endpoint", %{server_pid: server_pid} do
      # RunningServer.access_path
    end
  end
end
