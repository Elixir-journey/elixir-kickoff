# test/elixir_kickoff_application_test.exs
defmodule ElixirKickoff.ApplicationTest do
  @moduledoc """
  Tests for the ElixirKickoff.Application module.
  """

  use ExUnit.Case

  test "ensures the application starts correctly" do
    # Ensure the application is started, starting it only if necessary
    case Application.ensure_all_started(:elixir_kickoff) do
      {:ok, _apps} -> assert true
      {:error, {:already_started, _app}} -> assert true
    end
  end
end
