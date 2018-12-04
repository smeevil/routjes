defmodule Routjes.MixProject do
  use Mix.Project

  def project do
    [
      app: :routjes,
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore",
        flags: [
          :unknown,
          :error_handling,
          :race_conditions
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, ">= 0.0.0"},
      {:dialyxir, ">= 0.0.0", [only: :dev]},
      {:credo, ">= 0.0.0", [only: :dev]},
      {:poison, ">= 0.0.0"},
    ]
  end
end
