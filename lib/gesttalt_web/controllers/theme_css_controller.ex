defmodule GesttaltWeb.ThemeCSSController do
  @moduledoc """
  Controller that serves dynamic CSS based on the current theme.
  """

  use GesttaltWeb, :controller

  alias Gesttalt.Themes

  def show(conn, _params) do
    # Get the current theme from the process
    theme = Themes.get_theme()

    # Generate CSS using the Themes module
    css_content = Themes.theme_to_css(theme)

    conn
    |> put_resp_content_type("text/css")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, css_content)
  end
end
