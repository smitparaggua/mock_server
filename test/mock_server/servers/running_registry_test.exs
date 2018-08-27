defmodule MockServer.Servers.RunningRegistryTest do
  use ExUnit.Case
  alias MockServer.Servers.RunningRegistry

  setup do
    start_supervised!(RunningRegistry)
    :ok
  end

  test "registered pid are retrievable" do
    pid = self()
    RunningRegistry.register("key", pid)
    assert RunningRegistry.pid_of("key") == pid
  end

  test "non-existent keys return nil" do
    refute RunningRegistry.pid_of("key")
  end

  test "deleting key makes it unretrievable" do
    pid = self()
    RunningRegistry.register("key", pid)
    RunningRegistry.delete("key")
    refute RunningRegistry.pid_of("key")
  end
end
