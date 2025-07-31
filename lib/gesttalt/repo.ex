defmodule Gesttalt.Repo do
  use Ecto.Repo,
    otp_app: :gesttalt,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    # Configure UUIDv7 as the default primary key type
    config =
      config
      |> Keyword.put(:migration_primary_key, [type: :binary_id])
      |> Keyword.put(:migration_foreign_key, [type: :binary_id])

    {:ok, config}
  end
end
