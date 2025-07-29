defmodule Gesttalt.Themes.Theme.Colors do
  @moduledoc """
  Color scale for the theme following the Theme UI specification.
  """
  
  use TypedStruct
  
  typedstruct do
    plugin Gesttalt.Themes.JsonSchemaPlugin
    
    @typedoc "Theme colors following Theme UI spec"
    
    field :text, String.t(), default: "#000000"
    field :background, String.t(), default: "#ffffff"
    field :primary, String.t(), default: "#0066cc"
    field :secondary, String.t(), default: "#6c757d"
    field :accent, String.t(), default: "#609"
    field :highlight, String.t(), default: "#e8f4f8"
    field :muted, String.t(), default: "#f6f6f6"
    
    # Additional semantic colors
    field :success, String.t(), default: "#28a745"
    field :info, String.t(), default: "#17a2b8"
    field :warning, String.t(), default: "#ffc107"
    field :danger, String.t(), default: "#dc3545"
    
    # Color modes can be added as nested maps
    field :modes, %{optional(atom()) => map()}, default: %{}
  end
end