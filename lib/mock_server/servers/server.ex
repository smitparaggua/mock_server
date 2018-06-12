defmodule MockServer.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "servers" do
    field :name, :string
    field :path, :string
    field :description, :string
    timestamps()

    has_many :routes, MockServer.Servers.Route
  end

  def changeset(%__MODULE__{} = server, params) do
    cast(server, params, ~w(name path description)a)
  end
end
