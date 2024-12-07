IO.puts("Loading your Elixir project...")

# Alias common modules for easier usage
# Definitely add something that you'd always want access to.

# Import useful modules such as Eco.Query in the future.

# Automatically start the application (if required for testing functionality)
{:ok, _} = Application.ensure_all_started(:elixir_kickoff)

Mix.env() |> IO.inspect(label: "Environment")

# Add helpers for debugging
# defmodule IExHelpers do
#   def debug(data) do
#     IO.inspect(data, label: "Debug")
#   end
# end

# Add a custom welcome message
IO.puts("Session ready. Get debugging")
