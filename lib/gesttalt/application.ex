defmodule Gesttalt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GesttaltWeb.Telemetry,
      Gesttalt.Repo,
      {DNSCluster, query: Application.get_env(:gesttalt, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gesttalt.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gesttalt.Finch},
      # Start a worker by calling: Gesttalt.Worker.start_link(arg)
      # {Gesttalt.Worker, arg},
      # Start to serve requests, typically the last entry
      GesttaltWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gesttalt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GesttaltWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
