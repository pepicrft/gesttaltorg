defmodule Gesttalt.Schema do
  @moduledoc """
  Custom schema module that configures UUIDv7 as the default primary key type.
  
  Use this instead of `Ecto.Schema` to automatically get UUIDv7 primary keys
  and foreign keys in all your schemas.
  
  ## Usage
  
      defmodule MyApp.MySchema do
        use Gesttalt.Schema
        
        schema "my_table" do
          field :name, :string
          # id will automatically be a UUIDv7 binary_id
          
          timestamps()
        end
      end
  """
  
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      
      @primary_key {:id, UUIDv7.Type, autogenerate: true}
      @foreign_key_type UUIDv7.Type
      @timestamps_opts [type: :utc_datetime]
    end
  end
end