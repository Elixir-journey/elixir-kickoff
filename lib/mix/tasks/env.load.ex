defmodule Mix.Tasks.Env.Load do
  @shortdoc "Loads .env variables via dotenv_elixir (or Dotenvy)."

  @moduledoc false
  use Mix.Task

  def run(_) do
    env = Dotenv.load()
    System.put_env(env.values)

    if env.paths != [:none] and map_size(env.values) > 0 do
      Mix.shell().info("Loaded .env variables from #{inspect(env.paths)}.")
    else
      Mix.shell().info("No .env file or error loading.")
    end
  end
end
