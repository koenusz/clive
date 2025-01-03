defmodule Clive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CliveWeb.Telemetry,
      Clive.Repo,
      {DNSCluster, query: Application.get_env(:clive, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clive.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Clive.Finch},
      # Start a worker by calling: Clive.Worker.start_link(arg)
      # {Clive.Worker, arg},
      # Start to serve requests, typically the last entry
      CliveWeb.Endpoint,
      TwMerge.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CliveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
