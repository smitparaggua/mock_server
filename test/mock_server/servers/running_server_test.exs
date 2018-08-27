defmodule MockServer.Servers.RunningServerTest do
  use ExUnit.Case, async: true
  alias MockServer.Servers.{RunningServer, Server, Route}

  describe "access_path" do
    test "returns a response based on the configured route" do
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

      {:ok, server_pid} = start_supervised({RunningServer, server})
      assert RunningServer.access_path(server_pid, "GET", "/hello") == %{
        status_code: 200,
        response_type: "application/json",
        response_body: ~S({"hello": "world"})
      }
    end
  end
end
