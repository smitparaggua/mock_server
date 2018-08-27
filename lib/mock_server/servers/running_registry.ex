defmodule MockServer.Servers.RunningRegistry do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{} end, [name: __MODULE__] ++ opts)
  end

  def register(key, pid) do
    Agent.update(__MODULE__, fn state -> Map.put(state, key, pid) end)
  end

  def pid_of(key) do
    Agent.get(__MODULE__, fn state -> state[key] end)
  end

  def delete(key) do
    Agent.update(__MODULE__, fn state -> Map.delete(state, key) end)
  end
end
