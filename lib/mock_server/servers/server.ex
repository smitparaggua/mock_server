defmodule MockServer.Servers.Server do
  import MockServer.Changeset

  defstruct [:id, :name, :path, :description]

  def changeset(%__MODULE__{} = server, params) do
    cast(server, params, [:name, :path, :description])
  end
end
