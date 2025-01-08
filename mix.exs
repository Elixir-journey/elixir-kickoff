defmodule ElixirKickoff.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_kickoff,
      version: "0.1.0",
      elixir: "~> 1.13",
      erlang: "~> 25.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      dialyzer: [
        plt_add_apps: [:mix]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ElixirKickoff.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.3"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1"},
      {:sobelow, "~> 0.13.0"},
      {:styler, "~> 1.2", only: [:dev, :test], runtime: false},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]}
    ]
  end
end
