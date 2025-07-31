defmodule GesttaltWeb.ThemeCSSController do
  @moduledoc """
  Controller that serves dynamic CSS based on the current theme.
  """

  use GesttaltWeb, :controller

  alias Gesttalt.Themes

  def show(conn, params) do
    # Get theme from params or from process (set by ThemeLoaderPlug)
    theme = case params["theme"] do
      nil -> Themes.get_theme()
      theme_name -> Themes.get_theme_by_name(theme_name)
    end

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
