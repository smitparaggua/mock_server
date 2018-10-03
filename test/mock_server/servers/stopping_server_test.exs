defmodule MockServer.Servers.StoppingServerTest do
  use MockServer.DataCase

  @moduletag :run_server_processes

  import Destructure

  alias MockServer.TestSupport.ServersFactory
  alias MockServer.Servers

  setup do
    server = ServersFactory.create()
    {:ok, d%{server}}
  end

  test "stopping a running server returns stopped server", d%{server} do
    Servers.run(server)
    assert Servers.stop(server) == {:ok, server}
  end

  test "stopped server is no longer matched for its route", d%{server} do
    Servers.run(server)
    Servers.stop(server)
    assert Servers.server_for_path(String.split(server.path, "/", trim: true)) == nil
  end

  test "stopping a non running server returns {:ok, nil}", d%{server} do
    assert Servers.stop(server) == {:ok, nil}
  end
end
