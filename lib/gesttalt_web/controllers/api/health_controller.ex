defmodule GesttaltWeb.Api.HealthController do
  use GesttaltWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema

  defmodule HealthResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Health Response",
      description: "Health check response",
      type: :object,
      properties: %{
        status: %Schema{type: :string, description: "Health status", example: "ok"},
        timestamp: %Schema{type: :string, format: :datetime, description: "Response timestamp"}
      },
      required: [:status, :timestamp],
      example: %{
        "status" => "ok",
        "timestamp" => "2023-01-01T00:00:00Z"
      }
    })
  end

  operation :check,
    summary: "Health Check",
    description: "Returns the health status of the API",
    responses: [
      ok: {"Health status", "application/json", HealthResponse}
    ]

  def check(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
      status: "ok",
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end
end