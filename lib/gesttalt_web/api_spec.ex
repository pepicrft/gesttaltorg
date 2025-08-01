defmodule GesttaltWeb.ApiSpec do
  @moduledoc """
  OpenAPI specification for the Gesttalt API.
  """

  @behaviour OpenApiSpex.OpenApi

  alias GesttaltWeb.{Endpoint, Router}
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server}

  @impl OpenApiSpex.OpenApi
  def spec do
    %OpenApi{
      info: %Info{
        title: "Gesttalt API",
        description: "API for Gesttalt - A content organization platform",
        version: "1.0.0"
      },
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %OpenApiSpex.SecurityScheme{
            type: "http",
            scheme: "bearer"
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
