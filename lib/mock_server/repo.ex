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

  def get(collection, record_id) do
    GenServer.call(@name, {:get, collection, record_id})
  end

  # GenServer Callbacks

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:insert, changeset}, _from, state) do
    new_record =
      Map.merge(changeset.data, changeset.changes)
      |> Map.put(:id, UUID.uuid4())

    collection = changeset.data.__struct__
    new_state =
      state
      |> Map.put_new(collection, %{})
      |> put_in([collection, new_record.id], new_record)

    {:reply, {:ok, new_record}, new_state}
  end

  def handle_call({:get, collection, record_id}, _from, state) do
    record = get_in(state, [collection, record_id])
    {:reply, record, state}
  end
end
