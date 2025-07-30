defmodule GesttaltWeb.ThemeLoaderPlug do
  @moduledoc """
  A plug that loads the default theme into the process.
  This sets the theme in the process using Gesttalt.Themes.put_theme/1.
  """

  import Plug.Conn

  alias Gesttalt.Themes

  def init(default), do: default

  def call(conn, _default) do
    # Always use the default theme
    theme = Themes.default()

    # Put the theme in the process
    Themes.put_theme(theme)

    conn
  end
end
