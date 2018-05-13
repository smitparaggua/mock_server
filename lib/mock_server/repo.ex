defmodule MockServer.Repo do
  use GenServer

  @name __MODULE__

  def start_link_default(opts \\ []) do
    GenServer.start_link(__MODULE__, [], Keyword.put_new(opts, :name, @name))
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def stop(repo) do
    GenServer.stop(repo)
  end

  # Client

  def insert(changeset, options \\ []) do
    repo = Keyword.get(options, :repo, @name)
    GenServer.call(repo, {:insert, changeset})
  end

  def get(collection, record_id, options \\ []) do
    repo = Keyword.get(options, :repo, @name)
    GenServer.call(repo, {:get, collection, record_id})
  end

  def list(collection, options \\ []) do
    repo = Keyword.get(options, :repo, @name)
    GenServer.call(repo, {:list, collection, options})
  end

  def clear(repo \\ @name) do
    GenServer.call(repo, :clear)
  end

  # GenServer Callbacks

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(
    {:insert, %{__struct__: MockServer.Changeset} = changeset}, _from, state
  ) do
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

  def handle_call({:insert, object}, _from, state) do
    new_record = Map.put(object, :id, UUID.uuid4())
    collection = object.__struct__
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

  def handle_call({:list, collection, options}, from, state) do
    Task.start_link(fn ->
      records =
        state
        |> Map.get(collection, %{})
        |> Map.values()
        |> sort_records(Keyword.get(options, :order))

      GenServer.reply(from, records)
    end)

    {:noreply, state}
  end

  def handle_call(:clear, _from, _state) do
    {:reply, :ok, %{}}
  end

  defp sort_records(records, order_options) do
    case order_options do
      nil -> records

      {attribute, order} ->
        compare = if (order == :desc), do: &Kernel.>=/2, else: &Kernel.<=/2
        Enum.sort(records, fn left, right ->
          compare.(Map.get(left, attribute), Map.get(right, attribute))
        end)
    end
  end
end
