defmodule Gesttalt.Themes.Theme.Fonts do
  @moduledoc """
  Font families for the theme.
  """

  use TypedStruct

  alias Gesttalt.Themes.JsonSchemaPlugin

  typedstruct do
    plugin(JsonSchemaPlugin)

    @typedoc "Font family definitions"

    field :body, String.t(), default: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"

    field :heading, String.t(), default: "inherit"

    field :monospace, String.t(), default: "Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace"
  end
end
