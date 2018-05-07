defmodule MockServer.Repo do
  use GenServer

  @name __MODULE__

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], [name: @name] ++ opts)
  end

  # Client

  def insert(changeset) do
    GenServer.call(@name, {:insert, changeset})
  end

  def get(_model, record_id) do
    GenServer.call(@name, {:get, record_id})
  end

  # GenServer Callbacks

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:insert, changeset}, _from, state) do
    new_record =
      Map.merge(changeset.data, changeset.changes)
      |> Map.put(:id, UUID.uuid4())

    {:reply, {:ok, new_record}, Map.put(state, new_record.id, new_record)}
  end

  def handle_call({:get, record_id}, _from, state) do
    record = Map.get(state, record_id)
    {:reply, record, state}
  end
end
