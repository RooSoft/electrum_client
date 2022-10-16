defmodule ElectrumClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :electrum_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:jason, "~> 1.4"},
      {:bitcoinlib, "~> 0.2.0"}
    ]
  end
end
