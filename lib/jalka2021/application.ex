defmodule Jalka2021.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Jalka2021.Repo,
      # Start the Telemetry supervisor
      Jalka2021Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Jalka2021.PubSub},
      # Start the Endpoint (http/https)
      Jalka2021Web.Endpoint
      # Start a worker by calling: Jalka2021.Worker.start_link(arg)
      # {Jalka2021.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jalka2021.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Jalka2021Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
