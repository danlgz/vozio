defmodule Vozio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VozioWeb.Telemetry,
      Vozio.Repo,
      {DNSCluster, query: Application.get_env(:vozio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Vozio.PubSub},
      # Start a worker by calling: Vozio.Worker.start_link(arg)
      # {Vozio.Worker, arg},
      # Start to serve requests, typically the last entry
      VozioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vozio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VozioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
