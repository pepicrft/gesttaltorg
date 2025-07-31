defmodule GesttaltWeb.ThemeLoaderPlug do
  @moduledoc """
  A plug that loads the theme from cookies into the process.
  This sets the theme in the process using Gesttalt.Themes.put_theme/1.
  """

  import Plug.Conn
  alias Gesttalt.Themes

  def init(default), do: default

  def call(conn, _default) do
    # Get theme name from cookie, default to "default"
    theme_name = get_theme_from_cookie(conn)
    
    # Load the theme by name
    theme = Themes.get_theme_by_name(theme_name)

    # Put the theme in the process
    Themes.put_theme(theme)

    # Also assign to conn for use in templates
    conn
    |> assign(:current_theme, theme_name)
  end
  
  defp get_theme_from_cookie(conn) do
    conn
    |> fetch_cookies()
    |> Map.get(:cookies, %{})
    |> Map.get("theme", "default")
  end
end
