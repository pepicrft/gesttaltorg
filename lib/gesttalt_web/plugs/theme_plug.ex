defmodule GesttaltWeb.ThemePlug do
  @moduledoc """
  A plug that reads the user's theme preference from cookies and assigns it to the connection.
  """

  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    theme = get_theme_from_cookie(conn) || "light"
    assign(conn, :theme, theme)
  end

  defp get_theme_from_cookie(conn) do
    conn
    |> fetch_cookies()
    |> Map.get(:cookies, %{})
    |> Map.get("theme")
  end
end
