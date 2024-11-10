# test/elixir_kickoff_application_test.exs
defmodule ElixirKickoffApplicationTest do
  use ExUnit.Case

  @moduledoc """
  Tests for the ElixirKickoff.Application module.
  """

  test "ensures the application starts correctly" do
    # Ensure the application is started, starting it only if necessary
    case Application.ensure_all_started(:template_application) do
      {:ok, _apps} -> assert true
      {:error, {:already_started, _app}} -> assert true
    end
  end
end
