defmodule MockServer.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "servers" do
    field :name, :string
    field :path, :string
    field :description, :string
    field :running?, :boolean, virtual: true
    timestamps()

    has_many :routes, MockServer.Servers.Route
  end

  def changeset(%__MODULE__{} = server, params) do
    server
    |> cast(params, ~w(name path description)a)
    |> unique_constraint(:path)
    |> unique_constraint(:name)
  end
end
