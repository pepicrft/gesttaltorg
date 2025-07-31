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
  Returns a list of all available themes.
  """
  def all_themes do
    %{
      "default" => default(),
      "forest" => forest(),
      "ocean" => ocean(),
      "sunset" => sunset(),
      "monochrome" => monochrome()
    }
  end

  @doc """
  Returns the default theme.

  This is a minimal theme inspired by Are.na's aesthetic.
  """
  def default do
    %Theme{
      colors: %Theme.Colors{
        text: "#000000",
        background: "#ffffff",
        primary: "#0969DA",
        secondary: "#666666",
        accent: "#0066CC",
        highlight: "#E5E5E5",
        muted: "#F5F5F5",
        success: "#22C55E",
        info: "#0066CC",
        warning: "#D97706",
        danger: "#DC2626",
        modes: %{
          dark: %{
            "text" => "#F5F5F5",
            "background" => "#0A0A0A",
            "primary" => "#2F81F7",
            "secondary" => "#A0A0A0",
            "accent" => "#3B82F6",
            "highlight" => "#1F1F1F",
            "muted" => "#141414",
            "success" => "#10B981",
            "info" => "#3B82F6",
            "warning" => "#F59E0B",
            "danger" => "#F87171"
          }
        }
      },
      fonts: %Theme.Fonts{
        body: "Arial, Helvetica, sans-serif",
        heading: "Arial, Helvetica, sans-serif",
        monospace: "SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace"
      },
      font_sizes: [
        "0.78125rem",
        "0.875rem",
        "0.9rem",
        "1rem",
        "1.125rem",
        "1.25rem",
        "1.5rem",
        "2rem",
        "2.5rem",
        "3rem"
      ],
      font_weights: %Theme.FontWeights{
        body: 400,
        heading: 600,
        bold: 600,
        light: 300
      },
      line_heights: %Theme.LineHeights{
        body: 1.45,
        heading: 1.25
      },
      letter_spacings: %{
        normal: "normal",
        tracked: "0.02em",
        tight: "-0.02em"
      },
      space: [
        "0",
        "2px",
        "5px",
        "10px",
        "15px",
        "20px",
        "25px",
        "30px",
        "35px",
        "40px",
        "50px",
        "60px",
        "80px",
        "100px",
        "130px"
      ],
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
        default: "0px 0px 20px 0px rgba(0, 0, 0, 0.08)",
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
          "fontSize" => 3
        },
        h1: %{
          "fontFamily" => "heading",
          "fontWeight" => "body",
          "lineHeight" => "heading",
          "fontSize" => 3,
          "mt" => 0,
          "mb" => 4
        },
        h2: %{
          "fontFamily" => "heading",
          "fontWeight" => "body",
          "lineHeight" => "heading",
          "fontSize" => 3,
          "mt" => 0,
          "mb" => 4
        },
        h3: %{
          "fontFamily" => "heading",
          "fontWeight" => "body",
          "lineHeight" => "heading",
          "fontSize" => 3,
          "mt" => 0,
          "mb" => 4
        },
        p: %{
          "lineHeight" => "body",
          "mt" => 0,
          "mb" => 4
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
          "p" => 4,
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
  Forest theme with green and earth tones.
  """
  def forest do
    theme = default()

    %{
      theme
      | colors: %Theme.Colors{
          text: "#1A1F1A",
          background: "#FAFAF8",
          primary: "#2D5016",
          secondary: "#5C7C3E",
          accent: "#8B5A3C",
          highlight: "#E8E5D6",
          muted: "#F5F2E8",
          success: "#2D5016",
          info: "#5C7C3E",
          warning: "#D4A574",
          danger: "#A0522D",
          modes: %{
            dark: %{
              "text" => "#E8E5D6",
              "background" => "#0D0F0A",
              "primary" => "#5C7C3E",
              "secondary" => "#8B5A3C",
              "accent" => "#D4A574",
              "highlight" => "#1A1F1A",
              "muted" => "#141612",
              "success" => "#5C7C3E",
              "info" => "#8B5A3C",
              "warning" => "#D4A574",
              "danger" => "#A0522D"
            }
          }
        },
        fonts: %Theme.Fonts{
          body: "Charter, 'Bitstream Charter', 'Sitka Text', Cambria, serif",
          heading: "inherit",
          monospace: "'Cascadia Code', 'Source Code Pro', Consolas, 'Courier New', monospace"
        }
    }
  end

  @doc """
  Ocean theme with blue and aqua tones.
  """
  def ocean do
    theme = default()

    %{
      theme
      | colors: %Theme.Colors{
          text: "#0C1821",
          background: "#F8FCFF",
          primary: "#005577",
          secondary: "#0088CC",
          accent: "#00CED1",
          highlight: "#D6EAF8",
          muted: "#EBF5FB",
          success: "#20B2AA",
          info: "#0088CC",
          warning: "#FFB347",
          danger: "#FF6B6B",
          modes: %{
            dark: %{
              "text" => "#D6EAF8",
              "background" => "#0A0E14",
              "primary" => "#0088CC",
              "secondary" => "#00CED1",
              "accent" => "#20B2AA",
              "highlight" => "#1A2332",
              "muted" => "#0F151E",
              "success" => "#20B2AA",
              "info" => "#0088CC",
              "warning" => "#FFB347",
              "danger" => "#FF6B6B"
            }
          }
        },
        fonts: %Theme.Fonts{
          body: "Avenir Next, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif",
          heading: "inherit",
          monospace: "'SF Mono', Monaco, 'Inconsolata', 'Fira Code', monospace"
        }
    }
  end

  @doc """
  Sunset theme with warm orange and pink tones.
  """
  def sunset do
    theme = default()

    %{
      theme
      | colors: %Theme.Colors{
          text: "#2D1B00",
          background: "#FFF9F5",
          primary: "#FF6B35",
          secondary: "#F7931E",
          accent: "#FF1744",
          highlight: "#FFE5D9",
          muted: "#FFF5F0",
          success: "#4CAF50",
          info: "#2196F3",
          warning: "#F7931E",
          danger: "#FF1744",
          modes: %{
            dark: %{
              "text" => "#FFE5D9",
              "background" => "#1A0F0A",
              "primary" => "#FF6B35",
              "secondary" => "#F7931E",
              "accent" => "#FF1744",
              "highlight" => "#2D1B00",
              "muted" => "#201308",
              "success" => "#4CAF50",
              "info" => "#2196F3",
              "warning" => "#F7931E",
              "danger" => "#FF1744"
            }
          }
        },
        fonts: %Theme.Fonts{
          body: "Optima, Candara, 'Noto Sans', source-sans-pro, sans-serif",
          heading: "inherit",
          monospace: "'Cascadia Code', 'Source Code Pro', Consolas, 'Courier New', monospace"
        }
    }
  end

  @doc """
  Monochrome theme with grayscale colors.
  """
  def monochrome do
    theme = default()

    %{
      theme
      | colors: %Theme.Colors{
          text: "#000000",
          background: "#FFFFFF",
          primary: "#333333",
          secondary: "#666666",
          accent: "#999999",
          highlight: "#E5E5E5",
          muted: "#F5F5F5",
          success: "#444444",
          info: "#555555",
          warning: "#666666",
          danger: "#222222",
          modes: %{
            dark: %{
              "text" => "#F5F5F5",
              "background" => "#0A0A0A",
              "primary" => "#CCCCCC",
              "secondary" => "#999999",
              "accent" => "#666666",
              "highlight" => "#1F1F1F",
              "muted" => "#141414",
              "success" => "#BBBBBB",
              "info" => "#AAAAAA",
              "warning" => "#999999",
              "danger" => "#DDDDDD"
            }
          }
        },
        fonts: %Theme.Fonts{
          body: "'IBM Plex Sans', 'Helvetica Neue', Arial, sans-serif",
          heading: "inherit",
          monospace: "'IBM Plex Mono', 'Menlo', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', Courier, monospace"
        }
    }
  end

  @doc """
  Gets a theme by name.

  Returns the theme if found, or the default theme if not found.

  ## Examples

      theme = Gesttalt.Themes.get_theme_by_name("forest")
  """
  def get_theme_by_name(name) do
    Map.get(all_themes(), name, default())
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
  Generates comprehensive theme CSS with both light and dark modes.

  This includes CSS variables for all theme properties and additional
  styling rules that use those variables.
  """
  def theme_to_css(%Theme{} = theme) do
    # Generate CSS variables for light mode (default)
    light_vars = generate_css_vars(theme, "light")
    # Generate CSS variables for dark mode
    dark_vars = generate_css_vars(theme, "dark")

    """
    /* Dynamically generated theme CSS */
    /* Generated at: #{DateTime.utc_now() |> DateTime.to_string()} */

    /* Light mode (default) */
    :root {
    #{light_vars}
    }

    /* Dark mode - automatically applied based on browser/OS preference */
    @media (prefers-color-scheme: dark) {
      :root {
    #{dark_vars}
      }
    }

    /* Support for manual theme override via data-theme attribute */
    :root[data-theme="light"] {
    #{light_vars}
    }

    :root[data-theme="dark"] {
    #{dark_vars}
    }

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

  defp get_mode_colors(theme, mode) do
    if mode == "dark" && theme.colors.modes && is_map(theme.colors.modes) do
      # Try both atom and string keys for flexibility
      dark_colors = Map.get(theme.colors.modes, :dark) || Map.get(theme.colors.modes, "dark") || %{}

      if dark_colors == %{} do
        # No dark colors defined, use light colors
        theme.colors |> Map.from_struct() |> Map.delete(:modes)
      else
        # Convert string keys to atoms and merge with base colors
        dark_colors_atoms =
          dark_colors
          |> Map.new(fn
            {k, v} when is_binary(k) -> {String.to_existing_atom(k), v}
            {k, v} when is_atom(k) -> {k, v}
          end)

        theme.colors
        |> Map.from_struct()
        |> Map.delete(:modes)
        |> Map.merge(dark_colors_atoms)
      end
    else
      theme.colors |> Map.from_struct() |> Map.delete(:modes)
    end
  end

  defp generate_css_vars(theme, mode) do
    # Get colors for the specified mode
    colors = get_mode_colors(theme, mode)

    all_vars = [
      # Color variables
      Enum.map(colors, fn {key, value} ->
        "--color-#{key}: #{value}"
      end),
      # Font variables
      [
        "--fonts-body: #{theme.fonts.body}",
        "--fonts-heading: #{theme.fonts.heading}",
        "--fonts-monospace: #{theme.fonts.monospace}"
      ],
      # Font sizes
      theme.font_sizes
      |> Enum.with_index()
      |> Enum.map(fn {size, idx} -> "--font-sizes-#{idx}: #{size}" end),
      # Font weights
      [
        "--font-weights-body: #{theme.font_weights.body}",
        "--font-weights-heading: #{theme.font_weights.heading}",
        "--font-weights-bold: #{theme.font_weights.bold}",
        "--font-weights-light: #{theme.font_weights.light}",
        "--font-weights-medium: #{theme.font_weights.heading}"
      ],
      # Line heights
      [
        "--line-heights-body: #{theme.line_heights.body}",
        "--line-heights-heading: #{theme.line_heights.heading}"
      ],
      # Letter spacings
      Enum.map(theme.letter_spacings, fn {key, value} ->
        "--letter-spacings-#{key}: #{value}"
      end),
      # Space scale
      theme.space
      |> Enum.with_index()
      |> Enum.map(fn {space, idx} -> "--space-#{idx}: #{space}" end),
      # Other theme properties
      Enum.map(theme.sizes, fn {key, value} ->
        "--sizes-#{key}: #{value}"
      end),
      Enum.map(theme.radii, fn {key, value} ->
        "--radii-#{key}: #{value}"
      end),
      Enum.map(theme.borders, fn {key, value} ->
        "--borders-#{key}: #{value}"
      end),
      Enum.map(theme.border_widths, fn {key, value} ->
        "--border-widths-#{key}: #{value}"
      end),
      Enum.map(theme.border_styles, fn {key, value} ->
        "--border-styles-#{key}: #{value}"
      end),
      Enum.map(theme.shadows, fn {key, value} ->
        "--shadows-#{key}: #{value}"
      end),
      Enum.map(theme.transitions, fn {key, value} ->
        "--transitions-#{key}: #{value}"
      end),
      # Z-indices (convert underscores to hyphens)
      Enum.map(theme.z_indices, fn {key, value} ->
        key_str = key |> to_string() |> String.replace("_", "-")
        "--z-indices-#{key_str}: #{value}"
      end),
      # Common aliases
      [
        "--color-bg: var(--color-background)",
        "--max-width: var(--sizes-container)",
        "--border-radius: var(--radii-default)"
      ]
    ]

    vars =
      all_vars
      |> List.flatten()
      |> Enum.join(";\n  ")

    # Add final semicolon if vars is not empty
    if vars == "", do: vars, else: "  #{vars};"
  end
end
