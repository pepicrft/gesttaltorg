defmodule Gesttalt.Themes.Theme.Colors do
  @moduledoc """
  Color scale for the theme following the Theme UI specification.
  """

  use TypedStruct

  alias Gesttalt.Themes.JsonSchemaPlugin

  typedstruct do
    plugin(JsonSchemaPlugin)

    @typedoc "Theme colors following Theme UI spec"

    field :text, String.t(), default: "#000000"
    field :background, String.t(), default: "#ffffff"
    field :primary, String.t(), default: "#00CED1"
    field :secondary, String.t(), default: "#333333"
    field :accent, String.t(), default: "#3D46C2"
    field :highlight, String.t(), default: "#DEDEDE"
    field :muted, String.t(), default: "#FAFAFA"

    # Additional semantic colors
    field :success, String.t(), default: "#238020"
    field :info, String.t(), default: "#3D46C2"
    field :warning, String.t(), default: "#ff9500"
    field :danger, String.t(), default: "#B93D3D"

    # Color modes can be added as nested maps
    field :modes, %{optional(atom()) => map()}, default: %{}
  end
end
