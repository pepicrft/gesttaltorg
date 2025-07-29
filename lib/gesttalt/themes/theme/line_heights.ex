defmodule Gesttalt.Themes.Theme.LineHeights do
  @moduledoc """
  Line height scale for the theme.
  """

  use TypedStruct

  alias Gesttalt.Themes.JsonSchemaPlugin

  typedstruct do
    plugin(JsonSchemaPlugin)

    @typedoc "Line height definitions"

    field :body, float(), default: 1.5
    field :heading, float(), default: 1.125
  end
end
