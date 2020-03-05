defmodule Concordance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  # @registry :concordance_application_registry
  # @concordance :concordance_application_supervisor
  # @gutenburg :gutenburg_application_supervisor
  # @parsing :parsing_application_supervisor

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Concordance.Worker.start_link(arg)
      # {Concordance.Worker, arg}

      %{
        id: Concordance.DynamicSupervisor,
        start: {Concordance.DynamicSupervisor, :start_link, []},
      },
      %{
        id: Gutenburg.DynamicSupervisor,
        start: {Gutenburg.DynamicSupervisor, :start_link, []},
      },
      %{
        id: Parsing.DynamicSupervisor,
        start: {Parsing.DynamicSupervisor, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Concordance.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
