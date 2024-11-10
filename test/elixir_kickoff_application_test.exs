defmodule TemplateApplicationTest do
  use ExUnit.Case
  doctest TemplateApplication

  test "greets the world" do
    assert TemplateApplication.hello() == :world
  end
end
