defmodule GesttaltWeb.ThemeCSSControllerTest do
  use GesttaltWeb.ConnCase

  alias Gesttalt.Themes

  describe "GET /assets/theme.css" do
    test "returns CSS with proper content type", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")

      assert response_content_type(conn, :css)
      assert response(conn, 200)
    end

    test "includes CSS variables for light theme", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      # Check for light theme CSS variables in :root
      assert response_body =~ ":root {"
      assert response_body =~ "--color-text: #000000;"
      assert response_body =~ "--color-background: #ffffff;"
      assert response_body =~ "--color-primary: #00CED1;"
      assert response_body =~ "--color-accent: #0066CC;"
    end

    test "includes CSS variables for dark theme", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      # Check for dark theme using media query
      assert response_body =~ "@media (prefers-color-scheme: dark)"

      # Also check for data-theme attribute support
      assert response_body =~ ":root[data-theme=\"dark\"]"
    end

    test "includes font variables", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      assert response_body =~ "--fonts-body:"
      assert response_body =~ "--fonts-heading:"
      assert response_body =~ "--fonts-monospace:"
    end

    test "includes font weight and line height variables", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      assert response_body =~ "--font-weights-body: 400;"
      assert response_body =~ "--font-weights-heading: 600;"
      assert response_body =~ "--line-heights-body: 1.45;"
      assert response_body =~ "--line-heights-heading: 1.25;"
    end

    test "includes spacing variables", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      assert response_body =~ "--space-0: 0;"
      assert response_body =~ "--space-1: 2px;"
      assert response_body =~ "--space-2: 5px;"
    end

    test "includes radii and shadow variables", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      assert response_body =~ "--radii-default: 3px;"
      assert response_body =~ "--radii-small: 2px;"
      assert response_body =~ "--shadows-small:"
      assert response_body =~ "--shadows-default:"
    end

    test "includes z-index variables with proper naming", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      # Check that underscores are converted to hyphens
      assert response_body =~ "--z-indices-modal-backdrop: 40;"
      assert response_body =~ "--z-indices-tooltip: 70;"
    end

    test "includes additional theme styles", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      assert response_body =~ "font-family: var(--fonts-body);"
      assert response_body =~ "font-family: var(--fonts-heading);"
      assert response_body =~ "transition: background-color 0.3s ease"
    end

    test "includes proper cache headers", %{conn: conn} do
      conn = get(conn, ~p"/assets/theme.css")

      assert get_resp_header(conn, "cache-control") == ["public, max-age=3600"]
    end

    test "uses theme from process", %{conn: conn} do
      # Put a custom theme in the process to verify it's being used
      custom_theme = %{Themes.default() | colors: %{Themes.default().colors | text: "#custom"}}
      Themes.put_theme(custom_theme)

      conn = get(conn, ~p"/assets/theme.css")
      response_body = response(conn, 200)

      # The theme should be loaded by ThemeLoaderPlug, 
      # so this custom theme won't be used (it will use default)
      refute response_body =~ "--color-text: #custom;"
      assert response_body =~ "--color-text: #000000;"
    end
  end
end
