defmodule MockServer.Servers.Route do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "routes" do
    field :method, :string
    field :path, :string
    field :description, :string
    field :status_code, :integer  # validate if 200 < x < 600; maybe custom types?
    field :response_type, :string # TODO create valid choices
    field :response_body, :string
    belongs_to :server, MockServer.Servers.Server
  end

  def changeset(%__MODULE__{} = route, params) do
    fields =
      ~w(method path description status_code response_type response_body)a
    cast(route, params, fields)
  end
end
