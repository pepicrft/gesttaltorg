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
    plugin Gesttalt.Themes.JsonSchemaPlugin, camel_case: true
    
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
end