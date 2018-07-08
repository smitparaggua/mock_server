defmodule MockServer.Servers.Route do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields ~w(method path description status_code response_type response_body)a
  @required_fields ~w(method path status_code response_type response_body)a

  schema "routes" do
    field :method, :string
    field :path, :string
    field :description, :string
    field :status_code, :integer
    field :response_type, :string # TODO create valid choices
    field :response_body, :string
    belongs_to :server, MockServer.Servers.Server
  end

  def changeset(%__MODULE__{} = route \\ %__MODULE__{}, params) do
    response_types = ~w(
      application/json
      text/plain
      application/javascript
      application/xml
      text/xml
      text/html
    )
    cast(route, params, @fields)
    |> validate_required(@required_fields)
    |> validate_change(:status_code, &validate_http_status/2)
    |> validate_change(:method, &validate_http_verb/2)
    |> validate_inclusion(:response_type, response_types)
  end

  defp validate_http_status(field, value) do
    case Enum.member?(200..599, value) do
      true -> []
      false -> [{field, {"is not a valid HTTP status code", [validation: :http_status]}}]
    end
  end

  defp validate_http_verb(field, value) do
    case Enum.member?(~w(GET POST PUT PATCH DELETE), value) do
      true -> []
      false -> [{field, {"is not a valid HTTP verb", [validation: :http_verb]}}]
    end
  end
end
