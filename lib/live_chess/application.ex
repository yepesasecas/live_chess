defmodule LiveChess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveChess.Repo,
      # Start the Telemetry supervisor
      LiveChessWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveChess.PubSub},
      # Start the Endpoint (http/https)
      LiveChessWeb.Endpoint,
      # Start a worker by calling: LiveChess.Worker.start_link(arg)
      # {LiveChess.Worker, arg}
      LiveChess.Count,
      LiveChess.LiveGamesServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveChess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
