defmodule GesttaltWeb.ApiDocsHTML do
  @moduledoc """
  This module contains pages rendered by ApiDocsController.
  """

  use GesttaltWeb, :html

  embed_templates "api_docs_html/*"

  def extract_operations(%{
        get: get,
        post: post,
        put: put,
        delete: delete,
        patch: patch,
        head: head,
        options: options,
        trace: trace
      }) do
    [
      {:get, get},
      {:post, post},
      {:put, put},
      {:delete, delete},
      {:patch, patch},
      {:head, head},
      {:options, options},
      {:trace, trace}
    ]
    |> Enum.filter(fn {_method, operation} -> operation != nil end)
  end

  def extract_operations(_), do: []

  def format_path_parameters(parameters) when is_list(parameters) do
    parameters
    |> Enum.filter(&(&1.in == :path))
    |> Enum.map(&format_parameter/1)
  end

  def format_path_parameters(_), do: []

  def format_query_parameters(parameters) when is_list(parameters) do
    parameters
    |> Enum.filter(&(&1.in == :query))
    |> Enum.map(&format_parameter/1)
  end

  def format_query_parameters(_), do: []

  def format_request_body(request_body) when is_map(request_body) do
    content = Map.get(request_body, :content, %{})

    case Map.get(content, "application/json") do
      %{schema: schema} -> format_schema(schema)
      _ -> nil
    end
  end

  def format_request_body(_), do: nil

  def format_responses(responses) when is_map(responses) do
    responses
    |> Map.new(fn {status, response} ->
      {status, format_response(response)}
    end)
  end

  def format_responses(_), do: %{}

  defp format_parameter(param) do
    %{
      name: param.name,
      type: get_type(param.schema),
      required: param.required || false,
      description: get_description(param)
    }
  end

  defp format_response(response) when is_map(response) do
    content = Map.get(response, :content, %{})

    case Map.get(content, "application/json") do
      %{schema: schema} ->
        %{
          description: response.description,
          schema: format_schema(schema)
        }

      _ ->
        %{description: response.description}
    end
  end

  defp format_response(response), do: %{description: response}

  defp format_schema(%OpenApiSpex.Reference{"$ref": ref}) do
    # Extract schema name from reference path
    schema_name = ref |> String.split("/") |> List.last()
    %{type: "reference", description: "Reference to #{schema_name}", reference: ref}
  end

  defp format_schema(%{type: type, properties: properties}) when is_map(properties) do
    formatted_properties =
      properties
      |> Map.new(fn {key, prop} ->
        {key, %{type: get_type(prop), description: get_description(prop)}}
      end)

    %{type: type, properties: formatted_properties}
  end

  defp format_schema(%{type: type} = schema) do
    %{type: type, description: get_description(schema)}
  end

  defp format_schema(schema) when is_map(schema) do
    %{type: "object", description: get_description(schema)}
  end

  defp format_schema(_), do: %{type: "unknown"}

  defp get_type(%{type: type}), do: type
  defp get_type(_), do: "string"

  defp get_description(%{description: description}), do: description
  defp get_description(_), do: nil
end
