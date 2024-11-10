defmodule ElixirKickoff.Application do
  use Application

  def start(_type, _args) do
    IO.puts("TemplateApplication is running in the container!")
    :timer.sleep(100) # Small delay to ensure flush
    IO.puts("Log message successfully flushed")

    children = [
      # Define workers and supervisors to be started
    ]

    opts = [strategy: :one_for_one, name: TemplateApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
