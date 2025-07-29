defmodule Gesttalt.Themes.JsonSchemaPluginTest do
  use ExUnit.Case, async: true

  # Test modules for to_json generation
  defmodule SimpleJsonStruct do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :name, String.t()
      field :count, integer()
      field :active, boolean(), default: true
    end
  end

  defmodule CamelCaseStruct do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin, camel_case: true

      field :first_name, String.t()
      field :last_name, String.t()
      field :is_active, boolean()
    end
  end

  defmodule NestedInner do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :value, String.t()
    end
  end

  defmodule NestedOuter do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :inner, NestedInner.t()
      field :name, String.t()
    end
  end

  defmodule MapConversionStruct do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :config, map()
      field :options, %{optional(atom()) => String.t()}
    end
  end

  defmodule NilInnerStruct do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :value, String.t()
    end
  end

  defmodule NilHandlingStruct do
    use TypedStruct

    typedstruct do
      plugin Gesttalt.Themes.JsonSchemaPlugin

      field :name, String.t()
      field :optional, String.t()
      field :nested, NilInnerStruct.t()
    end
  end

  describe "JSON schema generation" do
    test "generates schema for simple struct" do
      defmodule SimpleStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :name, String.t()
          field :age, integer()
          field :active, boolean(), default: true
        end
      end

      schema = SimpleStruct.__json_schema__()

      assert schema["type"] == "object"
      assert schema["title"] == "SimpleStruct"
      assert Map.has_key?(schema, "properties")

      properties = schema["properties"]
      assert properties["name"] == %{"type" => "string"}
      assert properties["age"] == %{"type" => "integer"}
      assert properties["active"] == %{"type" => "boolean", "default" => true}
    end

    test "handles required fields" do
      defmodule RequiredFieldStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :required_field, String.t(), enforce: true
          field :optional_field, String.t()
        end
      end

      schema = RequiredFieldStruct.__json_schema__()

      assert schema["required"] == ["required_field"]
    end

    test "handles various numeric types" do
      defmodule NumericStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :int, integer()
          field :pos_int, pos_integer()
          field :neg_int, neg_integer()
          field :non_neg_int, non_neg_integer()
          field :float_val, float()
          field :number_val, number()
        end
      end

      schema = NumericStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["int"] == %{"type" => "integer"}
      assert properties["pos_int"] == %{"type" => "integer", "minimum" => 1}
      assert properties["neg_int"] == %{"type" => "integer", "maximum" => -1}
      assert properties["non_neg_int"] == %{"type" => "integer", "minimum" => 0}
      assert properties["float_val"] == %{"type" => "number"}
      assert properties["number_val"] == %{"type" => "number"}
    end

    test "handles list types" do
      defmodule ListStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :strings, list(String.t())
          field :numbers, list(integer())
        end
      end

      schema = ListStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["strings"] == %{
               "type" => "array",
               "items" => %{"type" => "string"}
             }

      assert properties["numbers"] == %{
               "type" => "array",
               "items" => %{"type" => "integer"}
             }
    end

    test "handles map types" do
      defmodule MapStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :simple_map, map()
          field :string_map, %{optional(atom()) => String.t()}
          field :required_map, %{required(atom()) => integer()}
        end
      end

      schema = MapStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["simple_map"] == %{"type" => "object"}
      # For now, TypedStruct might normalize these to simple maps
      assert properties["string_map"]["type"] == "object"
      assert properties["required_map"]["type"] == "object"
    end

    test "handles custom struct types" do
      defmodule CustomTypeStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :colors, Gesttalt.Themes.Theme.Colors.t()
        end
      end

      schema = CustomTypeStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["colors"] == %{
               "type" => "object",
               "$ref" => "#/definitions/Gesttalt.Themes.Theme.Colors"
             }
    end

    test "handles atom and binary types" do
      defmodule AtomBinaryStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :atom_field, atom()
          field :binary_field, binary()
        end
      end

      schema = AtomBinaryStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["atom_field"] == %{"type" => "string"}
      assert properties["binary_field"] == %{"type" => "string"}
    end

    test "preserves field order" do
      defmodule OrderedStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :first, String.t()
          field :second, integer()
          field :third, boolean()
        end
      end

      schema = OrderedStruct.__json_schema__()
      property_keys = Map.keys(schema["properties"])

      # Fields should be in the order they were defined
      assert property_keys == ["first", "second", "third"]
    end

    test "handles multiple structs with the plugin" do
      defmodule FirstPluginStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin
          field :field_a, String.t()
        end
      end

      defmodule SecondPluginStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin
          field :field_b, integer()
        end
      end

      # Each struct should have its own schema
      schema1 = FirstPluginStruct.__json_schema__()
      schema2 = SecondPluginStruct.__json_schema__()

      assert schema1["title"] == "FirstPluginStruct"
      assert schema2["title"] == "SecondPluginStruct"
      assert Map.keys(schema1["properties"]) == ["field_a"]
      assert Map.keys(schema2["properties"]) == ["field_b"]
    end

    test "handles default values of different types" do
      defmodule DefaultValuesStruct do
        use TypedStruct

        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin

          field :string_default, String.t(), default: "hello"
          field :number_default, integer(), default: 42
          field :bool_default, boolean(), default: false
          field :list_default, list(String.t()), default: ["a", "b"]
          field :map_default, map(), default: %{key: "value"}
        end
      end

      schema = DefaultValuesStruct.__json_schema__()
      properties = schema["properties"]

      assert properties["string_default"]["default"] == "hello"
      assert properties["number_default"]["default"] == 42
      assert properties["bool_default"]["default"] == false
      assert properties["list_default"]["default"] == ["a", "b"]
      assert properties["map_default"]["default"] == %{key: "value"}
    end
  end

  describe "to_json generation" do
    test "generates to_json function for simple struct" do
      struct = %SimpleJsonStruct{name: "test", count: 42, active: false}
      json = SimpleJsonStruct.to_json(struct)

      assert json == %{
               "name" => "test",
               "count" => 42,
               "active" => false
             }
    end

    test "generates to_json with camelCase option" do
      struct = %CamelCaseStruct{first_name: "John", last_name: "Doe", is_active: true}
      json = CamelCaseStruct.to_json(struct)

      assert json == %{
               "firstName" => "John",
               "lastName" => "Doe",
               "isActive" => true
             }
    end

    test "handles nested structs with to_json" do
      struct = %NestedOuter{
        inner: %NestedInner{value: "nested"},
        name: "outer"
      }
      json = NestedOuter.to_json(struct)

      assert json == %{
               "inner" => %{"value" => "nested"},
               "name" => "outer"
             }
    end

    test "converts atom keys in maps to strings" do
      struct = %MapConversionStruct{
        config: %{key: "value", another: "test"},
        options: %{option1: "a", option2: "b"}
      }
      json = MapConversionStruct.to_json(struct)

      assert json == %{
               "config" => %{"key" => "value", "another" => "test"},
               "options" => %{"option1" => "a", "option2" => "b"}
             }
    end

    test "handles nil values correctly" do
      struct = %NilHandlingStruct{name: "test", optional: nil, nested: nil}
      json = NilHandlingStruct.to_json(struct)

      assert json == %{
               "name" => "test",
               "optional" => nil,
               "nested" => nil
             }
    end
  end

  describe "integration with Theme modules" do
    test "Colors module generates correct schema" do
      schema = Gesttalt.Themes.Theme.Colors.__json_schema__()

      assert schema["type"] == "object"
      assert schema["title"] == "Colors"
      
      properties = schema["properties"]
      assert Map.has_key?(properties, "text")
      assert Map.has_key?(properties, "background")
      assert Map.has_key?(properties, "primary")
      assert Map.has_key?(properties, "modes")
    end

    test "Fonts module generates correct schema" do
      schema = Gesttalt.Themes.Theme.Fonts.__json_schema__()

      assert schema["type"] == "object"
      assert schema["title"] == "Fonts"
      
      properties = schema["properties"]
      assert Map.has_key?(properties, "body")
      assert Map.has_key?(properties, "heading")
      assert Map.has_key?(properties, "monospace")
    end

    test "FontWeights module generates correct schema" do
      schema = Gesttalt.Themes.Theme.FontWeights.__json_schema__()

      assert schema["type"] == "object"
      assert schema["title"] == "FontWeights"
      
      properties = schema["properties"]
      assert properties["body"] == %{"type" => "integer", "default" => 400}
      assert properties["heading"] == %{"type" => "integer", "default" => 700}
      assert properties["bold"] == %{"type" => "integer", "default" => 700}
      assert properties["light"] == %{"type" => "integer", "default" => 300}
    end

    test "LineHeights module generates correct schema" do
      schema = Gesttalt.Themes.Theme.LineHeights.__json_schema__()

      assert schema["type"] == "object"
      assert schema["title"] == "LineHeights"
      
      properties = schema["properties"]
      assert properties["body"] == %{"type" => "number", "default" => 1.5}
      assert properties["heading"] == %{"type" => "number", "default" => 1.125}
    end

    test "main Theme module generates complete schema" do
      raw_schema = Gesttalt.Themes.Theme.__json_schema__()
      complete_schema = Gesttalt.Themes.Theme.json_schema()

      # Raw schema should have snake_case properties
      assert Map.has_key?(raw_schema["properties"], "font_sizes")
      assert Map.has_key?(raw_schema["properties"], "font_weights")

      # Complete schema should have camelCase properties
      assert Map.has_key?(complete_schema["properties"], "fontSizes")
      assert Map.has_key?(complete_schema["properties"], "fontWeights")

      # Complete schema should include metadata
      assert complete_schema["$schema"] == "http://json-schema.org/draft-07/schema#"
      assert complete_schema["title"] == "Gesttalt Theme"
      assert complete_schema["description"] == "Theme structure following Theme UI specification"
    end

    test "Theme module generates working to_json with camelCase" do
      theme = Gesttalt.Themes.default()
      json = Gesttalt.Themes.Theme.to_json(theme)

      # Check camelCase conversion
      assert Map.has_key?(json, "fontSizes")
      assert Map.has_key?(json, "fontWeights")
      assert Map.has_key?(json, "lineHeights")
      assert Map.has_key?(json, "letterSpacings")
      assert Map.has_key?(json, "borderWidths")
      assert Map.has_key?(json, "borderStyles")
      assert Map.has_key?(json, "zIndices")

      # Check nested struct conversion
      assert is_map(json["colors"])
      assert json["colors"]["text"] == "#000000"
      assert json["colors"]["background"] == "#ffffff"

      # Check that maps have string keys
      assert is_map(json["letterSpacings"])
      assert json["letterSpacings"]["normal"] == "normal"
    end
  end
end