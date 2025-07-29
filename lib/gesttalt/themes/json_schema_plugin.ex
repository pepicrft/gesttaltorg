defmodule Gesttalt.Themes.JsonSchemaPlugin do
  @moduledoc """
  A TypedStruct plugin that generates JSON schema from struct definitions at compile time.
  
  This plugin collects field information during struct compilation and generates
  a corresponding JSON schema that can be accessed via a generated function.
  
  ## Usage
  
      defmodule MyStruct do
        use TypedStruct
        
        typedstruct do
          plugin Gesttalt.Themes.JsonSchemaPlugin
          
          field :name, String.t()
          field :age, integer()
          field :active, boolean(), default: true
        end
      end
      
      # Access the generated schema
      MyStruct.__json_schema__()
  """
  
  use TypedStruct.Plugin
  
  @impl true
  defmacro init(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :json_schema_fields, accumulate: true)
      @before_compile Gesttalt.Themes.JsonSchemaPlugin
    end
  end
  
  @impl true
  def field(name, type, opts, _env) do
    quote do
      @json_schema_fields {unquote(name), unquote(Macro.escape(type)), unquote(Macro.escape(opts))}
    end
  end
  
  @impl true
  def after_definition(_opts) do
    quote do
      # This runs after all fields are defined
    end
  end
  
  defmacro __before_compile__(env) do
    fields = Module.get_attribute(env.module, :json_schema_fields, [])
    schema = build_schema(env.module, fields)
    
    quote do
      @doc """
      Returns the JSON schema for this struct.
      Generated at compile time from the TypedStruct definition.
      """
      def __json_schema__ do
        unquote(Macro.escape(schema))
      end
    end
  end
  
  defp build_schema(module, fields) do
    properties = 
      fields
      |> Enum.reverse()  # Fields are accumulated in reverse order
      |> Enum.map(&field_to_property/1)
      |> Enum.into(%{})
    
    required = 
      fields
      |> Enum.reverse()
      |> Enum.filter(fn {_, _, opts} -> Keyword.get(opts, :enforce, false) end)
      |> Enum.map(fn {name, _, _} -> Atom.to_string(name) end)
    
    base_schema = %{
      "type" => "object",
      "title" => module |> Module.split() |> List.last(),
      "properties" => properties
    }
    
    if required == [] do
      base_schema
    else
      Map.put(base_schema, "required", required)
    end
  end
  
  defp field_to_property({name, type, opts}) do
    property = type_to_json_schema(type)
    
    # Add default value if present
    property = 
      case Keyword.get(opts, :default) do
        nil -> property
        default -> Map.put(property, "default", default)
      end
    
    {Atom.to_string(name), property}
  end
  
  # Convert Elixir types to JSON schema types
  defp type_to_json_schema({:integer, _, _}), do: %{"type" => "integer"}
  defp type_to_json_schema({:pos_integer, _, _}), do: %{"type" => "integer", "minimum" => 1}
  defp type_to_json_schema({:neg_integer, _, _}), do: %{"type" => "integer", "maximum" => -1}
  defp type_to_json_schema({:non_neg_integer, _, _}), do: %{"type" => "integer", "minimum" => 0}
  
  defp type_to_json_schema({:float, _, _}), do: %{"type" => "number"}
  defp type_to_json_schema({:number, _, _}), do: %{"type" => "number"}
  
  defp type_to_json_schema({:boolean, _, _}), do: %{"type" => "boolean"}
  defp type_to_json_schema({:atom, _, _}), do: %{"type" => "string"}
  defp type_to_json_schema({:binary, _, _}), do: %{"type" => "string"}
  
  # Handle String.t()
  defp type_to_json_schema({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, _}) do
    %{"type" => "string"}
  end
  
  # Handle list types like list(String.t())
  defp type_to_json_schema({:list, _, [item_type]}) do
    %{
      "type" => "array",
      "items" => type_to_json_schema(item_type)
    }
  end
  
  # Handle map types
  defp type_to_json_schema({:map, _, _}), do: %{"type" => "object"}
  
  # Handle %{optional(atom()) => type}
  defp type_to_json_schema({:%{}, _, [{:optional, _, _}, _]}) do
    %{"type" => "object", "additionalProperties" => true}
  end
  
  # Handle %{required(atom()) => type}
  defp type_to_json_schema({:%{}, _, [{:required, _, _}, _]}) do
    %{"type" => "object"}
  end
  
  # Handle specific map syntax for theme fields
  defp type_to_json_schema({:%{}, _, _}) do
    %{"type" => "object"}
  end
  
  # Handle struct types like Colors.t()
  defp type_to_json_schema({{:., _, [{:__aliases__, _, module_parts}, :t]}, _, _}) do
    # For now, treat custom types as objects
    # In a more sophisticated implementation, we could resolve these types
    %{"type" => "object", "$ref" => "#/definitions/#{Enum.join(module_parts, ".")}"}
  end
  
  # Default fallback
  defp type_to_json_schema(_type) do
    # IO.inspect(_type, label: "Unhandled type")
    %{"type" => "string"}
  end
end