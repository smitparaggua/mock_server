defmodule MockServer.Changeset do
  defstruct [:action, :data, :changes, :errors, :valid]

  def cast(data, changes, attributes) do
    changes = Enum.reduce(attributes, %{}, fn (attribute, acc) ->
      value = Map.get(changes, attribute) ||
        Map.get(changes, to_string(attribute))

      Map.put(acc, attribute, value)
    end)

    %__MODULE__{data: data, changes: changes}
  end
end
