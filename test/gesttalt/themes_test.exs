defmodule Gesttalt.ThemesTest do
  use ExUnit.Case, async: true

  alias Gesttalt.Themes
  alias Gesttalt.Themes.Theme

  describe "default/0" do
    test "returns a valid default theme" do
      theme = Themes.default()

      assert %Theme{} = theme
      assert theme.colors.text == "#000000"
      assert theme.colors.background == "#ffffff"
      assert theme.fonts.body =~ "Arial"
      assert length(theme.font_sizes) == 10
      assert theme.colors.modes.dark["text"] == "#ffffff"
    end
  end

  describe "get_theme/0 and put_theme/1" do
    test "returns default theme when no theme is set" do
      # Clear any existing theme
      Process.delete({Themes, :theme})

      theme = Themes.get_theme()
      assert theme == Themes.default()
    end

    test "stores and retrieves theme from process" do
      custom_theme = %{Themes.default() | colors: %{Themes.default().colors | text: "#333333"}}

      Themes.put_theme(custom_theme)
      retrieved = Themes.get_theme()

      assert retrieved == custom_theme
      assert retrieved.colors.text == "#333333"
    end

    test "put_theme returns the theme" do
      theme = Themes.default()
      result = Themes.put_theme(theme)

      assert result == theme
    end
  end

  describe "from_map/1" do
    test "creates theme from valid map with partial data" do
      map = %{
        "colors" => %{
          "text" => "#333",
          "background" => "#f0f0f0"
        }
      }

      assert {:ok, theme} = Themes.from_map(map)
      assert theme.colors.text == "#333"
      assert theme.colors.background == "#f0f0f0"
      # Other colors should have defaults
      assert theme.colors.primary == "#000000"
    end

    test "creates theme with custom fonts" do
      map = %{
        "fonts" => %{
          "body" => "Georgia, serif",
          "heading" => "Helvetica, sans-serif"
        }
      }

      assert {:ok, theme} = Themes.from_map(map)
      assert theme.fonts.body == "Georgia, serif"
      assert theme.fonts.heading == "Helvetica, sans-serif"
    end

    test "creates theme with font weights" do
      map = %{
        "fontWeights" => %{
          "body" => 300,
          "heading" => 900
        }
      }

      assert {:ok, theme} = Themes.from_map(map)
      assert theme.font_weights.body == 300
      assert theme.font_weights.heading == 900
    end

    test "returns error for invalid input type" do
      assert {:error, "Input must be a map"} = Themes.from_map("not a map")
      assert {:error, "Input must be a map"} = Themes.from_map(123)
      assert {:error, "Input must be a map"} = Themes.from_map(nil)
    end
  end

  describe "from_json_string/1" do
    test "creates theme from valid JSON string" do
      json = ~s({"colors": {"text": "#111", "background": "#eee"}})

      assert {:ok, theme} = Themes.from_json_string(json)
      assert theme.colors.text == "#111"
      assert theme.colors.background == "#eee"
    end

    test "returns error for invalid JSON" do
      json = ~s({invalid json})

      assert {:error, message} = Themes.from_json_string(json)
      assert message =~ "Invalid JSON"
    end

    test "returns error for non-string input" do
      assert {:error, "Input must be a string"} = Themes.from_json_string(123)
      assert {:error, "Input must be a string"} = Themes.from_json_string(%{})
    end
  end

  describe "json_schema/0" do
    test "returns a valid JSON schema" do
      schema = Themes.json_schema()

      assert schema["$schema"] == "http://json-schema.org/draft-07/schema#"
      assert schema["type"] == "object"
      assert schema["title"] == "Gesttalt Theme"
      assert is_map(schema["properties"])
      assert is_map(schema["properties"]["colors"])
      assert is_map(schema["properties"]["fonts"])
    end
  end

  describe "to_css_variables/1" do
    test "generates CSS variables from theme" do
      theme = Themes.default()
      css = Themes.to_css_variables(theme)

      assert css =~ ":root {"
      assert css =~ "--colors-text: #000000;"
      assert css =~ "--colors-background: #ffffff;"
      assert css =~ "--fonts-body:"
      assert css =~ "--fontsizes-0: 0.78125rem;"
      assert css =~ "--space-0: 0;"
    end
  end

  describe "theme_style_tag/1" do
    test "generates Phoenix HTML safe style tag" do
      theme = Themes.default()
      {:safe, html} = Themes.theme_style_tag(theme)

      html_string = IO.iodata_to_binary(html)
      assert html_string =~ "<style>"
      assert html_string =~ ":root {"
      assert html_string =~ "--colors-text: #000000;"
      assert html_string =~ "</style>"
    end

    test "uses current theme when no theme provided" do
      custom_theme = %{Themes.default() | colors: %{Themes.default().colors | text: "#custom"}}
      Themes.put_theme(custom_theme)

      {:safe, html} = Themes.theme_style_tag()
      html_string = IO.iodata_to_binary(html)

      assert html_string =~ "--colors-text: #custom;"
    end
  end

  describe "Theme.to_json/1" do
    test "converts theme to JSON with camelCase keys" do
      theme = Themes.default()
      json = Theme.to_json(theme)

      assert json["colors"]["text"] == "#000000"
      assert json["fontSizes"] == theme.font_sizes
      assert json["fontWeights"]["body"] == 400
      assert json["lineHeights"]["body"] == 1.45
      assert json["letterSpacings"]["normal"] == "normal"
    end
  end
end
