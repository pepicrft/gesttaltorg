# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

alias Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  gesttalt: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :gesttalt, Gesttalt.Mailer, adapter: Local

# Configures the endpoint
config :gesttalt, GesttaltWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: GesttaltWeb.ErrorHTML, json: GesttaltWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Gesttalt.PubSub,
  live_view: [signing_salt: "lJQtzaTB"]

config :gesttalt,
  ecto_repos: [Gesttalt.Repo],
  generators: [
    timestamp_type: :utc_datetime,
    binary_id: true
  ]

# Configure Ecto to use UUIDv7 for primary keys
config :gesttalt, Gesttalt.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure MIME types for RSS and Atom feeds
config :mime, :types, %{
  "application/rss+xml" => ["rss"],
  "application/atom+xml" => ["atom"]
}

import_config "#{config_env()}.exs"
