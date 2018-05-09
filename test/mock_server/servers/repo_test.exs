defmodule MockServer.RepoTest do
  use ExUnit.Case, async: true
  import Destructure
  alias MockServer.Repo
  alias MockServer.Changeset

  defmodule Person do
    defstruct [:name, :age]
  end

  defmodule Address do
    defstruct [:street, :city]
  end

  setup_all do
    {:ok, repo} = Repo.start_link()
    {:ok, d(%{repo})}
  end

  describe ".insert/1" do
    test "allows inserting valid changesets", d(%{repo}) do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      assert {:ok, created} = Repo.insert(repo, changeset)
      assert created.name == "Joe"
      assert created.id
    end

    test "allows inserting structs directly", d(%{repo}) do
      assert {:ok, created} = Repo.insert(repo, %Person{name: "Joe"})
      assert created.name == "Joe"
      assert created.id
    end
  end

  describe ".get/2" do
    test "created records are retrievable by ID", d(%{repo}) do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(repo, changeset)
      assert Repo.get(repo, Person, created.id) == created
    end

    test "separates records of different models", d(%{repo}) do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(repo, changeset)
      refute Repo.get(repo, Address, created.id)
    end
  end

  describe ".list/1" do
    setup do
      {:ok, repo} = Repo.start_link()
      {:ok, d(%{repo})}
    end

    test "returns all records in the collection", d(%{repo}) do
      {:ok, created1} = Repo.insert(repo, %Person{name: "Joe"})
      {:ok, created2} = Repo.insert(repo, %Person{name: "Andy"})
      {:ok, created3} = Repo.insert(repo, %Person{name: "Ken"})
      list = Repo.list(repo, Person)
      expected = [created1, created2, created3]
      assert matches_members?(list, expected),
        "left: #{inspect list}\nright: #{inspect expected}"
    end
  end

  defp matches_members?(left, right) do
    ListUtils.element_occurrence(left) == ListUtils.element_occurrence(right)
  end
end
