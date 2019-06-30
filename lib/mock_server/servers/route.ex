defmodule MockServer.Servers.Route do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w(method path status_code response_type response_body)a
  @fields ~w(
    method path description status_code response_type response_body
    response_delay_seconds
  )a

  @response_types ~w(
    application/json text/plain application/javascript application/xml
    text/xml text/html
  )

  schema "routes" do
    field :method, :string
    field :path, :string
    field :description, :string
    field :status_code, :integer
    field :response_type, :string # TODO create valid choices
    field :response_body, :string
    field :response_delay_seconds, :integer
    belongs_to :server, MockServer.Servers.Server
  end

  def changeset(%__MODULE__{} = route \\ %__MODULE__{}, params) do
    cast(route, params, @fields)
    |> validate_required(@required_fields)
    |> validate_change(:status_code, &validate_http_status/2)
    |> validate_change(:method, &validate_http_verb/2)
    |> validate_response_type()
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

  defp validate_response_type(changeset) do
    validate_inclusion(
      changeset,
      :response_type,
      @response_types,
      message: "is not a valid HTTP response type"
    )
  end
end
