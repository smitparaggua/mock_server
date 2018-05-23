defmodule MockServer.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :name, :string
    field :path, :string
    field :description, :string
    timestamps()
  end

  def changeset(%__MODULE__{} = server, params) do
    cast(server, params, ~w(name path description)a)
  end
end
