defmodule GesttaltWeb.ThemeController do
  use GesttaltWeb, :controller
  
  alias Gesttalt.Themes
  
  def update(conn, %{"theme" => theme_name}) do
    # Validate theme exists
    if Map.has_key?(Themes.all_themes(), theme_name) do
      conn
      |> put_resp_cookie("theme", theme_name, max_age: 60 * 60 * 24 * 365) # 1 year
      |> put_flash(:info, "Theme changed to #{theme_name}")
      |> redirect(to: get_return_path(conn))
    else
      conn
      |> put_flash(:error, "Invalid theme")
      |> redirect(to: get_return_path(conn))
    end
  end
  
  defp get_return_path(conn) do
    case get_req_header(conn, "referer") do
      [referer | _] -> URI.parse(referer).path || "/"
      _ -> "/"
    end
  end
end