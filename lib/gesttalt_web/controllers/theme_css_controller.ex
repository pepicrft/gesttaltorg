defmodule GesttaltWeb.ThemeCSSController do
  @moduledoc """
  Controller that serves dynamic CSS based on the current theme.
  """

  use GesttaltWeb, :controller

  alias Gesttalt.Themes

  def show(conn, _params) do
    # Get the current theme from the process
    theme = Themes.get_theme()

    # Generate CSS variables
    css_content = generate_theme_css(theme)

    conn
    |> put_resp_content_type("text/css")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, css_content)
  end

  defp generate_theme_css(theme) do
    # Generate CSS for both light and dark modes
    light_css = generate_mode_css(theme, "light")
    dark_css = generate_mode_css(theme, "dark")

    """
    /* Dynamically generated theme CSS */
    /* Generated at: #{DateTime.utc_now() |> DateTime.to_string()} */

    #{light_css}

    #{dark_css}

    /* Additional theme-specific styles */
    body {
      font-family: var(--fonts-body);
      line-height: var(--line-heights-body);
      font-weight: var(--font-weights-body);
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    h1, h2, h3, h4, h5, h6 {
      font-family: var(--fonts-heading);
      font-weight: var(--font-weights-heading);
      line-height: var(--line-heights-heading);
    }

    code, pre {
      font-family: var(--fonts-monospace);
    }

    a {
      transition: color 0.2s ease;
    }

    button {
      transition: all 0.2s ease;
    }
    """
  end

  defp generate_mode_css(theme, mode) do
    # Get colors for the mode
    colors =
      if mode == "dark" do
        dark_colors = get_in(theme, [:colors, :modes, "dark"]) || %{}

        theme.colors
        |> Map.from_struct()
        |> Map.delete(:modes)
        |> Map.merge(dark_colors)
      else
        theme.colors |> Map.from_struct() |> Map.delete(:modes)
      end

    # Convert theme data to CSS variables
    css_vars = []

    # Add color variables
    css_vars =
      css_vars ++
        Enum.map(colors, fn {key, value} ->
          "  --color-#{key}: #{value};"
        end)

    # Add font variables
    if theme.fonts do
      fonts = Map.from_struct(theme.fonts)

      css_vars =
        css_vars ++
          Enum.map(fonts, fn {key, value} ->
            "  --fonts-#{key}: #{value};"
          end)
    end

    # Add font weight variables
    if theme.font_weights do
      weights = Map.from_struct(theme.font_weights)

      css_vars =
        css_vars ++
          Enum.map(weights, fn {key, value} ->
            "  --font-weights-#{key}: #{value};"
          end)
    end

    # Add line height variables
    if theme.line_heights do
      heights = Map.from_struct(theme.line_heights)

      css_vars =
        css_vars ++
          Enum.map(heights, fn {key, value} ->
            "  --line-heights-#{key}: #{value};"
          end)
    end

    # Add space variables
    if theme.space do
      space_vars =
        theme.space
        |> Enum.with_index()
        |> Enum.map(fn {value, index} ->
          "  --space-#{index}: #{value};"
        end)

      css_vars = css_vars ++ space_vars
    end

    # Add radii variables
    if theme.radii do
      css_vars =
        css_vars ++
          Enum.map(theme.radii, fn {key, value} ->
            "  --radii-#{key}: #{value};"
          end)
    end

    # Add shadow variables
    if theme.shadows do
      css_vars =
        css_vars ++
          Enum.map(theme.shadows, fn {key, value} ->
            "  --shadows-#{key}: #{value};"
          end)
    end

    # Add transition variables
    if theme.transitions do
      css_vars =
        css_vars ++
          Enum.map(theme.transitions, fn {key, value} ->
            "  --transitions-#{key}: #{value};"
          end)
    end

    # Add z-index variables
    if theme.z_indices do
      css_vars =
        css_vars ++
          Enum.map(theme.z_indices, fn {key, value} ->
            "  --z-indices-#{String.replace(key, "_", "-")}: #{value};"
          end)
    end

    """
    :root[data-theme="#{mode}"] {
    #{Enum.join(css_vars, "\n")}
    }
    """
  end
end
