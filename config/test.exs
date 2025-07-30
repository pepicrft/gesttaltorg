import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used

# In test we don't send emails
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
alias Swoosh.Adapters.Test

config :gesttalt, Gesttalt.Mailer, adapter: Test

config :gesttalt, Gesttalt.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "gesttalt_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  pool_size: System.schedulers_online() * 2

config :gesttalt, GesttaltWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ff0zn+EPYavGmb3PvujA8bDKHzZAbXqIm0O2PsLn2EwmQECm5uThq1KNnZa9aZCu",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
