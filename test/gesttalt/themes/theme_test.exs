defmodule Gesttalt.Themes.ThemeTest do
  use ExUnit.Case, async: true
  
  alias Gesttalt.Themes.Theme
  
  describe "struct defaults" do
    test "creates theme with all default values" do
      theme = %Theme{}
      
      assert theme.colors.text == "#000000"
      assert theme.colors.background == "#ffffff"
      assert theme.fonts.body =~ "system-ui"
      assert theme.font_weights.body == 400
      assert theme.line_heights.body == 1.5
      assert theme.space == ["0", "4px", "8px", "16px", "32px", "64px", "128px", "256px"]
    end
  end
  
  describe "nested structs" do
    test "Colors struct has correct defaults" do
      colors = %Theme.Colors{}
      
      assert colors.text == "#000000"
      assert colors.background == "#ffffff"
      assert colors.primary == "#0066cc"
      assert colors.modes == %{}
    end
    
    test "Fonts struct has correct defaults" do
      fonts = %Theme.Fonts{}
      
      assert fonts.body =~ "system-ui"
      assert fonts.heading == "inherit"
      assert fonts.monospace =~ "Consolas"
    end
    
    test "FontWeights struct has correct defaults" do
      weights = %Theme.FontWeights{}
      
      assert weights.body == 400
      assert weights.heading == 700
      assert weights.bold == 700
      assert weights.light == 300
    end
    
    test "LineHeights struct has correct defaults" do
      heights = %Theme.LineHeights{}
      
      assert heights.body == 1.5
      assert heights.heading == 1.125
    end
  end
  
  describe "json_schema/0" do
    test "generates complete JSON schema" do
      schema = Theme.json_schema()
      
      assert schema["$schema"] == "http://json-schema.org/draft-07/schema#"
      assert schema["type"] == "object"
      
      # Check main properties exist
      properties = schema["properties"]
      assert properties["colors"]
      assert properties["fonts"]
      assert properties["fontSizes"]
      assert properties["fontWeights"]
      assert properties["lineHeights"]
      assert properties["space"]
      assert properties["shadows"]
      assert properties["transitions"]
    end
    
    test "color schema includes all color properties" do
      schema = Theme.json_schema()
      color_props = schema["properties"]["colors"]["properties"]
      
      assert color_props["text"]["type"] == "string"
      assert color_props["background"]["type"] == "string"
      assert color_props["primary"]["type"] == "string"
      assert color_props["modes"]["type"] == "object"
    end
  end
  
  describe "validation edge cases" do
    test "validates nested color modes" do
      json = %{
        "colors" => %{
          "modes" => %{
            "dark" => %{
              "text" => "#fff"
            }
          }
        }
      }
      
      assert :ok = Theme.validate_json(json)
    end
    
    test "accepts float values for line heights" do
      json = %{
        "lineHeights" => %{
          "body" => 1.5,
          "heading" => 1.25
        }
      }
      
      assert :ok = Theme.validate_json(json)
    end
    
    test "accepts integer values for line heights" do
      json = %{
        "lineHeights" => %{
          "body" => 2,
          "heading" => 1
        }
      }
      
      assert :ok = Theme.validate_json(json)
    end
  end
  
  describe "to_json/1" do
    test "includes all theme properties" do
      theme = %Theme{}
      json = Theme.to_json(theme)
      
      # Check all top-level keys are present
      expected_keys = [
        "colors", "fonts", "fontSizes", "fontWeights", "lineHeights",
        "letterSpacings", "space", "sizes", "radii", "borders",
        "borderWidths", "borderStyles", "shadows", "transitions",
        "zIndices", "variants", "styles"
      ]
      
      Enum.each(expected_keys, fn key ->
        assert Map.has_key?(json, key), "Missing key: #{key}"
      end)
    end
    
    test "preserves custom values" do
      theme = %Theme{
        colors: %Theme.Colors{text: "#custom"},
        fonts: %Theme.Fonts{body: "Custom Font"},
        font_sizes: ["10px", "20px"],
        variants: %{"custom" => %{"test" => true}}
      }
      
      json = Theme.to_json(theme)
      
      assert json["colors"]["text"] == "#custom"
      assert json["fonts"]["body"] == "Custom Font"
      assert json["fontSizes"] == ["10px", "20px"]
      assert json["variants"]["custom"]["test"] == true
    end
  end
end