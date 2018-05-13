defmodule MockServer.RepoTest do
  use ExUnit.Case, async: true
  import Destructure
  alias MockServer.{Repo, Changeset, Assertions}

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
      assert {:ok, created} = Repo.insert(changeset, repo: repo)
      assert created.name == "Joe"
      assert created.id
    end

    test "allows inserting structs directly", d(%{repo}) do
      assert {:ok, created} = Repo.insert(%Person{name: "Joe"}, repo: repo)
      assert created.name == "Joe"
      assert created.id
    end
  end

  describe ".get/2" do
    test "created records are retrievable by ID", d(%{repo}) do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(changeset, repo: repo)
      assert Repo.get(Person, created.id, repo: repo) == created
    end

    test "separates records of different models", d(%{repo}) do
      changeset = Changeset.cast(%Person{}, %{name: "Joe"}, [:name])
      {:ok, created} = Repo.insert(changeset, repo: repo)
      refute Repo.get(Address, created.id, repo: repo)
    end
  end

  describe ".list/1" do
    setup do
      {:ok, repo} = Repo.start_link()
      {:ok, d(%{repo})}
    end

    test "returns all records in the collection", d(%{repo}) do
      created = insert_records(repo)
      list = Repo.list(Person, repo: repo)
      Assertions.matches_members?(list, created)
    end

    test "returns empty list when collection does not exist", d(%{repo}) do
      assert Repo.list(Person, repo: repo) == []
    end

    test "allows ordering ascending", d(%{repo}) do
      created = insert_records(repo)
      list = Repo.list(Person, order: {:name, :asc}, repo: repo)
      assert list ==
        [Enum.at(created, 1), Enum.at(created, 0), Enum.at(created, 2)]
    end

    test "allows ordering descending", d(%{repo}) do
      created = insert_records(repo)
      list = Repo.list(Person, order: {:name, :desc}, repo: repo)
      assert list ==
        [Enum.at(created, 2), Enum.at(created, 0), Enum.at(created, 1)]
    end

    defp insert_records(repo) do
      {:ok, created1} = Repo.insert(%Person{name: "Joe"}, repo: repo)
      {:ok, created2} = Repo.insert(%Person{name: "Andy"}, repo: repo)
      {:ok, created3} = Repo.insert(%Person{name: "Ken"}, repo: repo)
      [created1, created2, created3]
    end
  end

  describe ".clear/0" do
    setup do
      {:ok, repo} = Repo.start_link()
      {:ok, d(%{repo})}
    end

    test "deletes all records", d(%{repo}) do
      Repo.insert(%Person{name: "Joe"}, repo: repo)
      Repo.insert(%Address{street: "San Rafael St."}, repo: repo)
      Repo.clear(repo)
      assert Repo.list(Person, repo: repo) == []
      assert Repo.list(Address, repo: repo) == []
    end
  end
end
