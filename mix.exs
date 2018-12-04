defmodule Routjes.MixProject do
  use Mix.Project

  def project do
    [
      app: :routjes,
      version: "1.0.0",
      description: """
        An Elixir library that can extract the Phoenix router paths and create a java/typescript module of them.
      """,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
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
      {:credo, ">= 0.0.0", [only: :dev]},
      {:dialyxir, ">= 0.0.0", [only: :dev]},
      {:phoenix, ">= 0.0.0"},
      {:poison, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0"},
    ]
  end

  defp package do
    [
      maintainers: ["Gerard de Brieder"],
      licenses: ["WTFPL"],
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      links: %{
        "GitHub" => "https://github.com/smeevil/routjes",
      }
    ]
  end
end
