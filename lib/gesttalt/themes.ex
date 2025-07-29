defmodule Gesttalt.Themes do
  @moduledoc """
  Theme management for Gesttalt.

  This module provides functions to work with themes, including
  loading, validating, and applying themes to the application.

  ## Process-based theme storage

  Similar to Gettext, themes can be stored in the current process:

      Gesttalt.Themes.put_theme(my_theme)
      current = Gesttalt.Themes.get_theme()
  """

  alias Gesttalt.Themes.Theme

  @process_key {__MODULE__, :theme}

  @doc """
  Returns the default theme.

  This is a minimal theme inspired by Are.na's aesthetic.
  """
  def default do
    %Theme{
      colors: %Theme.Colors{
        text: "#000000",
        background: "#ffffff",
        primary: "#000000",
        secondary: "#666666",
        accent: "#0066ff",
        highlight: "#f0f0f0",
        muted: "#f8f8f8",
        success: "#00a86b",
        info: "#0066ff",
        warning: "#ff9500",
        danger: "#ff3b30",
        modes: %{
          dark: %{
            "text" => "#ffffff",
            "background" => "#000000",
            "primary" => "#ffffff",
            "secondary" => "#999999",
            "accent" => "#0066ff",
            "highlight" => "#1a1a1a",
            "muted" => "#0a0a0a",
            "success" => "#00a86b",
            "info" => "#0066ff",
            "warning" => "#ff9500",
            "danger" => "#ff3b30"
          }
        }
      },
      fonts: %Theme.Fonts{
        body: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif",
        heading: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif",
        monospace: "Monaco, Consolas, 'Lucida Console', monospace"
      },
      font_sizes: ["11px", "13px", "15px", "17px", "21px", "27px", "35px", "59px"],
      font_weights: %Theme.FontWeights{
        body: 400,
        heading: 600,
        bold: 600,
        light: 300
      },
      line_heights: %Theme.LineHeights{
        body: 1.6,
        heading: 1.2
      },
      letter_spacings: %{
        normal: "normal",
        tracked: "0.02em",
        tight: "-0.02em"
      },
      space: ["0", "4px", "8px", "12px", "16px", "24px", "32px", "48px", "64px", "96px"],
      sizes: %{
        container: "1200px",
        narrow: "800px",
        measure: "65ch"
      },
      radii: %{
        default: "3px",
        small: "2px",
        large: "6px",
        circle: "50%"
      },
      borders: %{
        default: "1px solid",
        thick: "2px solid"
      },
      border_widths: %{
        default: "1px",
        thick: "2px"
      },
      border_styles: %{
        default: "solid",
        dashed: "dashed",
        dotted: "dotted"
      },
      shadows: %{
        small: "0 1px 2px rgba(0, 0, 0, 0.05)",
        default: "0 2px 4px rgba(0, 0, 0, 0.1)",
        large: "0 8px 16px rgba(0, 0, 0, 0.1)",
        inset: "inset 0 2px 4px rgba(0, 0, 0, 0.06)"
      },
      transitions: %{
        default: "all 0.2s ease",
        fast: "all 0.1s ease",
        slow: "all 0.3s ease"
      },
      z_indices: %{
        base: 0,
        dropdown: 10,
        sticky: 20,
        fixed: 30,
        modal_backdrop: 40,
        modal: 50,
        popover: 60,
        tooltip: 70
      },
      variants: %{
        buttons: %{
          primary: %{
            "color" => "background",
            "bg" => "primary",
            "borderRadius" => "default",
            "px" => 3,
            "py" => 2,
            "fontSize" => 1,
            "fontWeight" => "bold",
            "cursor" => "pointer",
            "transition" => "default",
            "&:hover" => %{
              "opacity" => 0.8
            }
          },
          secondary: %{
            "color" => "primary",
            "bg" => "transparent",
            "border" => "default",
            "borderColor" => "primary",
            "borderRadius" => "default",
            "px" => 3,
            "py" => 2,
            "fontSize" => 1,
            "fontWeight" => "bold",
            "cursor" => "pointer",
            "transition" => "default",
            "&:hover" => %{
              "bg" => "muted"
            }
          }
        },
        cards: %{
          default: %{
            "bg" => "background",
            "border" => "default",
            "borderColor" => "muted",
            "borderRadius" => "default",
            "p" => 3
          },
          hover: %{
            "bg" => "background",
            "border" => "default",
            "borderColor" => "muted",
            "borderRadius" => "default",
            "p" => 3,
            "transition" => "default",
            "cursor" => "pointer",
            "&:hover" => %{
              "borderColor" => "primary",
              "boxShadow" => "default"
            }
          }
        }
      },
      styles: %{
        root: %{
          "fontFamily" => "body",
          "lineHeight" => "body",
          "fontWeight" => "body",
          "fontSize" => 2
        },
        h1: %{
          "fontFamily" => "heading",
          "fontWeight" => "heading",
          "lineHeight" => "heading",
          "fontSize" => 6,
          "mt" => 0,
          "mb" => 3
        },
        h2: %{
          "fontFamily" => "heading",
          "fontWeight" => "heading",
          "lineHeight" => "heading",
          "fontSize" => 5,
          "mt" => 0,
          "mb" => 3
        },
        h3: %{
          "fontFamily" => "heading",
          "fontWeight" => "heading",
          "lineHeight" => "heading",
          "fontSize" => 4,
          "mt" => 0,
          "mb" => 3
        },
        p: %{
          "lineHeight" => "body",
          "mt" => 0,
          "mb" => 3
        },
        a: %{
          "color" => "primary",
          "textDecoration" => "underline",
          "&:hover" => %{
            "color" => "accent"
          }
        },
        pre: %{
          "fontFamily" => "monospace",
          "bg" => "muted",
          "p" => 3,
          "borderRadius" => "default",
          "overflowX" => "auto"
        },
        code: %{
          "fontFamily" => "monospace",
          "bg" => "muted",
          "px" => 1,
          "borderRadius" => "small"
        }
      }
    }
  end

  @doc """
  Gets the theme from the current process.

  Returns the default theme if no theme is set.

  ## Examples

      theme = Gesttalt.Themes.get_theme()
  """
  def get_theme do
    Process.get(@process_key, default())
  end

  @doc """
  Puts a theme in the current process.

  ## Examples

      Gesttalt.Themes.put_theme(my_theme)
  """
  def put_theme(%Theme{} = theme) do
    Process.put(@process_key, theme)
    theme
  end

  @doc """
  Creates a theme from a map.

  The map should use string keys with camelCase naming (Theme UI convention).
  Returns `{:ok, theme}` on success or `{:error, reason}` on failure.

  ## Examples

      {:ok, theme} = Gesttalt.Themes.from_map(%{
        "colors" => %{
          "text" => "#000",
          "background" => "#fff"
        }
      })
  """
  def from_map(map) when is_map(map) do
    theme = build_theme_from_map(map)
    {:ok, theme}
  end

  def from_map(_), do: {:error, "Input must be a map"}

  @doc """
  Creates a theme from a JSON string.

  Returns `{:ok, theme}` on success or `{:error, reason}` on failure.

  ## Examples

      json = ~s({"colors": {"text": "#000", "background": "#fff"}})
      {:ok, theme} = Gesttalt.Themes.from_json_string(json)
  """
  def from_json_string(json_string) when is_binary(json_string) do
    case Jason.decode(json_string) do
      {:ok, map} ->
        from_map(map)

      {:error, %Jason.DecodeError{} = error} ->
        {:error, "Invalid JSON: #{Exception.message(error)}"}
    end
  end

  def from_json_string(_), do: {:error, "Input must be a string"}

  @doc """
  Returns the current theme as JSON.
  """
  def current_theme_json do
    get_theme() |> Theme.to_json()
  end

  @doc """
  Returns the JSON schema for themes.
  """
  def json_schema do
    Theme.json_schema()
  end

  @doc """
  Generates CSS custom properties from a theme.

  This creates CSS variables that can be used in stylesheets.

  ## Examples

      theme = Gesttalt.Themes.get_theme()
      css = Gesttalt.Themes.to_css_variables(theme)
      css =~ "--color-text: #000000;"
      true
  """
  def to_css_variables(%Theme{} = theme) do
    theme_json = Theme.to_json(theme)

    variables =
      theme_json
      |> flatten_theme_object()
      |> Enum.map_join("\n  ", fn {key, value} ->
        css_var_name = key |> String.replace(".", "-") |> String.downcase()
        "--#{css_var_name}: #{value};"
      end)

    """
    :root {
      #{variables}
    }
    """
  end

  @doc """
  Injects theme CSS variables into a Phoenix layout.

  This can be used in your root layout to make theme variables available.
  """
  def theme_style_tag(theme \\ nil) do
    theme = theme || get_theme()
    css = to_css_variables(theme)

    Phoenix.HTML.raw("""
    <style>
    #{css}
    </style>
    """)
  end

  # Private functions

  defp build_theme_from_map(map) do
    %Theme{
      colors: build_colors(map["colors"] || %{}),
      fonts: build_fonts(map["fonts"] || %{}),
      font_sizes: map["fontSizes"] || Theme.__struct__().font_sizes,
      font_weights: build_font_weights(map["fontWeights"] || %{}),
      line_heights: build_line_heights(map["lineHeights"] || %{}),
      letter_spacings: map["letterSpacings"] || Theme.__struct__().letter_spacings,
      space: map["space"] || Theme.__struct__().space,
      sizes: map["sizes"] || Theme.__struct__().sizes,
      radii: map["radii"] || Theme.__struct__().radii,
      borders: map["borders"] || Theme.__struct__().borders,
      border_widths: map["borderWidths"] || Theme.__struct__().border_widths,
      border_styles: map["borderStyles"] || Theme.__struct__().border_styles,
      shadows: map["shadows"] || Theme.__struct__().shadows,
      transitions: map["transitions"] || Theme.__struct__().transitions,
      z_indices: map["zIndices"] || Theme.__struct__().z_indices,
      variants: map["variants"] || Theme.__struct__().variants,
      styles: map["styles"] || Theme.__struct__().styles
    }
  end

  defp build_colors(colors_map) when is_map(colors_map) do
    default = %Theme.Colors{}

    %Theme.Colors{
      text: colors_map["text"] || default.text,
      background: colors_map["background"] || default.background,
      primary: colors_map["primary"] || default.primary,
      secondary: colors_map["secondary"] || default.secondary,
      accent: colors_map["accent"] || default.accent,
      highlight: colors_map["highlight"] || default.highlight,
      muted: colors_map["muted"] || default.muted,
      success: colors_map["success"] || default.success,
      info: colors_map["info"] || default.info,
      warning: colors_map["warning"] || default.warning,
      danger: colors_map["danger"] || default.danger,
      modes: colors_map["modes"] || default.modes
    }
  end

  defp build_colors(_), do: %Theme.Colors{}

  defp build_fonts(fonts_map) when is_map(fonts_map) do
    default = %Theme.Fonts{}

    %Theme.Fonts{
      body: fonts_map["body"] || default.body,
      heading: fonts_map["heading"] || default.heading,
      monospace: fonts_map["monospace"] || default.monospace
    }
  end

  defp build_fonts(_), do: %Theme.Fonts{}

  defp build_font_weights(weights_map) when is_map(weights_map) do
    default = %Theme.FontWeights{}

    %Theme.FontWeights{
      body: weights_map["body"] || default.body,
      heading: weights_map["heading"] || default.heading,
      bold: weights_map["bold"] || default.bold,
      light: weights_map["light"] || default.light
    }
  end

  defp build_font_weights(_), do: %Theme.FontWeights{}

  defp build_line_heights(heights_map) when is_map(heights_map) do
    default = %Theme.LineHeights{}

    %Theme.LineHeights{
      body: heights_map["body"] || default.body,
      heading: heights_map["heading"] || default.heading
    }
  end

  defp build_line_heights(_), do: %Theme.LineHeights{}

  defp flatten_theme_object(theme, prefix \\ "") do
    theme
    |> Enum.flat_map(fn {key, value} ->
      full_key = if prefix == "", do: key, else: "#{prefix}-#{key}"

      case value do
        # Skip complex nested objects like variants, styles, and modes
        %{} = _map when key in ["variants", "styles", "modes"] ->
          []

        # Recursively flatten nested maps
        %{} = map when is_map(map) and map != %{} ->
          flatten_theme_object(map, full_key)

        list when is_list(list) ->
          # For arrays, create indexed variables
          list
          |> Enum.with_index()
          |> Enum.map(fn {item, index} ->
            {"#{full_key}-#{index}", to_string(item)}
          end)

        value when is_number(value) or is_binary(value) or is_atom(value) ->
          [{full_key, to_string(value)}]

        _ ->
          []
      end
    end)
  end
end

