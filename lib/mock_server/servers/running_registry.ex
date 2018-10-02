defmodule MockServer.Servers.RunningRegistry do
  use Agent

  def start_link() do
    start_link([])
  end

  def start_link(opts) do
    Agent.start_link(fn -> %{} end, [name: __MODULE__] ++ opts)
  end

  @spec register(String.t, pid) :: :ok
  def register(key, pid) do
    Agent.update(__MODULE__, fn state -> Map.put(state, key, pid) end)
  end

  @spec running?(String.t) :: boolean
  def running?(key) do
    !!pid_of(key)
  end

  def pid_of(key) do
    Agent.get(__MODULE__, fn state -> state[key] end)
  end

  def delete(key) do
    Agent.get_and_update(__MODULE__, fn state ->
      {Map.get(state, key), Map.delete(state, key)}
    end)
  end
end
