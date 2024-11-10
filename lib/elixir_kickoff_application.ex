defmodule ElixirKickoff.Application do
  @moduledoc """
  The main application module for ElixirKickoff.

  This module is the entry point for starting the application. It initializes
  the supervision tree and logs a message when the application starts in the container.
  """
  use Application

  def start(_type, _args) do
    IO.puts("TemplateApplication is running in the container!")
    # Small delay to ensure flush
    :timer.sleep(100)
    IO.puts("Log message successfully flushed")

    children = [
      # Define workers and supervisors to be started
    ]

    opts = [strategy: :one_for_one, name: TemplateApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
