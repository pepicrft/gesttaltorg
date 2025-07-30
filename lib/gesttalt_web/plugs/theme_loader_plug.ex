defmodule GesttaltWeb.ThemeLoaderPlug do
  @moduledoc """
  A plug that loads the theme into the process based on the user's preference.
  This sets the theme in the process using Gesttalt.Themes.put_theme/1.
  """

  import Plug.Conn

  alias Gesttalt.Themes
  alias Gesttalt.Themes.Theme.Colors

  def init(default), do: default

  def call(conn, _default) do
    # Get theme name from assigns (set by ThemePlug from cookie)
    theme_name = conn.assigns[:theme] || "light"

    # Get the appropriate theme based on the name
    theme =
      case theme_name do
        "dark" ->
          # Get default theme and apply dark mode colors
          default_theme = Themes.default()
          dark_colors = get_in(default_theme, [:colors, :modes, "dark"]) || %{}

          # Merge dark mode colors into the main colors
          updated_colors =
            default_theme.colors
            |> Map.from_struct()
            |> Map.merge(dark_colors)
            |> then(fn colors ->
              struct(Colors, colors)
            end)

          %{default_theme | colors: updated_colors}

        _ ->
          Themes.default()
      end

    # Put the theme in the process
    Themes.put_theme(theme)

    conn
  end
end
