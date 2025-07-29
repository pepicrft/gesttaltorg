defmodule Gesttalt.Themes.Theme do
  @moduledoc """
  Theme structure following the Theme UI specification.
  
  This module defines the theme structure for Gesttalt, providing a compile-time
  typed struct that follows the Theme UI specification. It includes colors,
  typography, spacing, and other design tokens.
  
  ## Usage
  
      theme = %Gesttalt.Themes.Theme{
        colors: %Gesttalt.Themes.Theme.Colors{
          text: "#000",
          background: "#fff",
          primary: "#07c"
        },
        fonts: %Gesttalt.Themes.Theme.Fonts{
          body: "system-ui, sans-serif",
          heading: "inherit",
          monospace: "Menlo, monospace"
        }
      }
  
  ## JSON Schema
  
  You can get the JSON schema representation using:
  
      Gesttalt.Themes.Theme.json_schema()
  """
  
  use TypedStruct
  
  alias __MODULE__.{Colors, Fonts, FontWeights, LineHeights}
  
  # Main theme structure
  typedstruct do
    plugin Gesttalt.Themes.JsonSchemaPlugin
    
    @typedoc """
    The main theme structure following Theme UI specification.
    """
    
    # Colors
    field :colors, Colors.t(), default: %Colors{}
    
    # Typography
    field :fonts, Fonts.t(), default: %Fonts{}
    field :font_sizes, list(String.t()), default: ["12px", "14px", "16px", "20px", "24px", "32px", "48px", "64px"]
    field :font_weights, FontWeights.t(), default: %FontWeights{}
    field :line_heights, LineHeights.t(), default: %LineHeights{}
    field :letter_spacings, map(), default: %{
      normal: "normal",
      tracked: "0.1em",
      tight: "-0.05em"
    }
    
    # Spacing
    field :space, list(String.t()), default: ["0", "4px", "8px", "16px", "32px", "64px", "128px", "256px"]
    
    # Sizing
    field :sizes, map(), default: %{
      container: "1024px",
      measure: "32em"
    }
    
    # Borders
    field :radii, map(), default: %{
      default: "4px",
      circle: "99999px"
    }
    field :borders, map(), default: %{}
    field :border_widths, map(), default: %{
      default: "1px"
    }
    field :border_styles, map(), default: %{
      default: "solid"
    }
    
    # Shadows
    field :shadows, map(), default: %{
      default: "0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24)",
      large: "0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23)"
    }
    
    # Other
    field :transitions, map(), default: %{
      default: "all 0.3s ease-in-out"
    }
    field :z_indices, map(), default: %{
      dropdown: 1000,
      sticky: 1020,
      fixed: 1030,
      modal_backdrop: 1040,
      modal: 1050,
      popover: 1060,
      tooltip: 1070
    }
    
    # Variants for components
    field :variants, map(), default: %{}
    
    # Styles for MDX/markdown elements
    field :styles, map(), default: %{}
  end
  
  @doc """
  Returns the JSON schema for the theme structure.
  
  This schema is generated at compile time from the TypedStruct definition.
  """
  def json_schema do
    base_schema = __json_schema__()
    
    # Merge with sub-schemas
    properties = base_schema["properties"]
    
    # Transform property names to camelCase and merge sub-schemas
    transformed_properties = %{
      "colors" => Colors.__json_schema__(),
      "fonts" => Fonts.__json_schema__(),
      "fontSizes" => properties["font_sizes"],
      "fontWeights" => FontWeights.__json_schema__(),
      "lineHeights" => LineHeights.__json_schema__(),
      "letterSpacings" => properties["letter_spacings"],
      "space" => properties["space"],
      "sizes" => properties["sizes"],
      "radii" => properties["radii"],
      "borders" => properties["borders"],
      "borderWidths" => properties["border_widths"],
      "borderStyles" => properties["border_styles"],
      "shadows" => properties["shadows"],
      "transitions" => properties["transitions"],
      "zIndices" => properties["z_indices"],
      "variants" => properties["variants"],
      "styles" => properties["styles"]
    }
    
    %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "type" => "object",
      "title" => "Gesttalt Theme",
      "description" => "Theme structure following Theme UI specification",
      "properties" => transformed_properties
    }
  end
  
  @doc """
  Converts the theme struct to a JSON-compatible map.
  Uses camelCase keys to match Theme UI convention.
  """
  def to_json(%__MODULE__{} = theme) do
    %{
      "colors" => colors_to_json(theme.colors),
      "fonts" => fonts_to_json(theme.fonts),
      "fontSizes" => theme.font_sizes,
      "fontWeights" => font_weights_to_json(theme.font_weights),
      "lineHeights" => line_heights_to_json(theme.line_heights),
      "letterSpacings" => atomize_keys_to_strings(theme.letter_spacings),
      "space" => theme.space,
      "sizes" => atomize_keys_to_strings(theme.sizes),
      "radii" => atomize_keys_to_strings(theme.radii),
      "borders" => atomize_keys_to_strings(theme.borders),
      "borderWidths" => atomize_keys_to_strings(theme.border_widths),
      "borderStyles" => atomize_keys_to_strings(theme.border_styles),
      "shadows" => atomize_keys_to_strings(theme.shadows),
      "transitions" => atomize_keys_to_strings(theme.transitions),
      "zIndices" => atomize_keys_to_strings(theme.z_indices),
      "variants" => theme.variants,
      "styles" => theme.styles
    }
  end
  
  @doc """
  Validates a theme JSON against the schema.
  
  Since ex_json_schema has compatibility issues with Elixir 1.18,
  this performs basic structural validation.
  """
  def validate_json(json) when is_map(json) do
    # Basic validation - check if required fields are present and correct types
    with :ok <- validate_colors(json["colors"]),
         :ok <- validate_fonts(json["fonts"]),
         :ok <- validate_array_field(json["fontSizes"], "string"),
         :ok <- validate_font_weights(json["fontWeights"]),
         :ok <- validate_line_heights(json["lineHeights"]) do
      :ok
    end
  end
  
  def validate_json(_), do: {:error, "Theme must be a map"}
  
  # Private helper functions
  
  defp atomize_keys_to_strings(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      key = if is_atom(k), do: Atom.to_string(k), else: k
      {key, v}
    end)
    |> Enum.into(%{})
  end
  
  defp colors_to_json(%Colors{} = colors) do
    %{
      "text" => colors.text,
      "background" => colors.background,
      "primary" => colors.primary,
      "secondary" => colors.secondary,
      "accent" => colors.accent,
      "highlight" => colors.highlight,
      "muted" => colors.muted,
      "success" => colors.success,
      "info" => colors.info,
      "warning" => colors.warning,
      "danger" => colors.danger,
      "modes" => colors.modes
    }
  end
  
  defp fonts_to_json(%Fonts{} = fonts) do
    %{
      "body" => fonts.body,
      "heading" => fonts.heading,
      "monospace" => fonts.monospace
    }
  end
  
  defp font_weights_to_json(%FontWeights{} = weights) do
    %{
      "body" => weights.body,
      "heading" => weights.heading,
      "bold" => weights.bold,
      "light" => weights.light
    }
  end
  
  defp line_heights_to_json(%LineHeights{} = heights) do
    %{
      "body" => heights.body,
      "heading" => heights.heading
    }
  end
  
  defp validate_colors(nil), do: :ok
  defp validate_colors(colors) when is_map(colors), do: :ok
  defp validate_colors(_), do: {:error, "colors must be a map"}
  
  defp validate_fonts(nil), do: :ok
  defp validate_fonts(fonts) when is_map(fonts), do: :ok
  defp validate_fonts(_), do: {:error, "fonts must be a map"}
  
  defp validate_font_weights(nil), do: :ok
  defp validate_font_weights(weights) when is_map(weights) do
    if Enum.all?(weights, fn {_, v} -> is_integer(v) end) do
      :ok
    else
      {:error, "fontWeights values must be integers"}
    end
  end
  defp validate_font_weights(_), do: {:error, "fontWeights must be a map"}
  
  defp validate_line_heights(nil), do: :ok
  defp validate_line_heights(heights) when is_map(heights) do
    if Enum.all?(heights, fn {_, v} -> is_number(v) end) do
      :ok
    else
      {:error, "lineHeights values must be numbers"}
    end
  end
  defp validate_line_heights(_), do: {:error, "lineHeights must be a map"}
  
  defp validate_array_field(nil, _), do: :ok
  defp validate_array_field(array, type) when is_list(array) do
    case type do
      "string" ->
        if Enum.all?(array, &is_binary/1) do
          :ok
        else
          {:error, "array must contain only strings"}
        end
      _ ->
        :ok
    end
  end
  defp validate_array_field(_, _), do: {:error, "field must be an array"}
end