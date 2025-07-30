defmodule GesttaltWeb.ThemeController do
  use GesttaltWeb, :controller

  def toggle(conn, %{"theme" => theme}) when theme in ["light", "dark"] do
    conn
    |> put_resp_cookie("theme", theme, max_age: 365 * 24 * 60 * 60)
    |> json(%{theme: theme})
  end

  def toggle(conn, _params) do
    current_theme = conn.assigns[:theme] || "light"
    new_theme = if current_theme == "light", do: "dark", else: "light"
    
    conn
    |> put_resp_cookie("theme", new_theme, max_age: 365 * 24 * 60 * 60)
    |> json(%{theme: new_theme})
  end
end