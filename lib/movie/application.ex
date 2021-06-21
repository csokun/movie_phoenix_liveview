defmodule Movie.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp media_server_config,
    do: %{
      path: System.fetch_env!("MEDIA_PATH")
    }

  def start(_type, _args) do
    children = [
      {Movie.MediaServer, media_server_config()},
      # Start the Telemetry supervisor
      MovieWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Movie.PubSub},
      # Start the Endpoint (http/https)
      MovieWeb.Endpoint
      # Start a worker by calling: Movie.Worker.start_link(arg)
      # {Movie.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Movie.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MovieWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
