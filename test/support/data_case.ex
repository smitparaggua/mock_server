defmodule MockServer.DataCase do
  @moduledoc """
  This module defines the test case used by tests that require writing to the
  database.

  It clears the records after every test when test is not async.
  """

  use ExUnit.CaseTemplate
  alias MockServer.Repo

  using do
    quote do
      alias MockServer.{Repo, Changeset}
    end
  end

  setup tags do
    unless tags[:async] do
      on_exit fn -> Repo.clear() end
    end

    :ok
  end
end
