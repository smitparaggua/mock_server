defmodule MockServer.ListUtils do
  def element_occurrence(list) when is_list(list) do
    Enum.reduce(list, %{}, fn (element, acc) ->
      Map.update(acc, element, 1, &(&1 + 1))
    end)
  end
end
