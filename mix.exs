defmodule Playwright.MixProject do
  use Mix.Project

  def project do
    [
      app: :playwright_elixir,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Playwright.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:plug, "~> 1.11.1"},
      {:plug_cowboy, "~> 2.5.0"},
      {:websockex, "~> 0.4.3"}
    ]
  end
end
