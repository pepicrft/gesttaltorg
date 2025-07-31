defmodule GesttaltWeb.ThemeCSSController do
  @moduledoc """
  Controller that serves dynamic CSS based on the current theme.
  """

  use GesttaltWeb, :controller

  alias Gesttalt.Themes

  def show(conn, _params) do
    # Get the current theme from the process (set by ThemeLoaderPlug)
    theme = Themes.get_theme()

    # Generate CSS using the Themes module
    css_content = Themes.theme_to_css(theme)

    # In development, don't cache; in production, cache for 1 hour
    cache_control = 
      if Application.get_env(:gesttalt, :env) == :dev do
        "no-cache, no-store, must-revalidate"
      else
        "public, max-age=3600"
      end

    conn
    |> put_resp_content_type("text/css")
    |> put_resp_header("cache-control", cache_control)
    |> send_resp(200, css_content)
  end
end
