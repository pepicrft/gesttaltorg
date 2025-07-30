defmodule Gesttalt.Themes.Theme.FontWeights do
  @moduledoc """
  Font weight scale for the theme.
  """

  use TypedStruct

  alias Gesttalt.Themes.JsonSchemaPlugin

  typedstruct do
    plugin(JsonSchemaPlugin)

    @typedoc "Font weight definitions"

    field :body, integer(), default: 400
    field :heading, integer(), default: 700
    field :bold, integer(), default: 700
    field :light, integer(), default: 300
  end
end
