defmodule ElectrumClient.MixProject do
  use Mix.Project

  @version "0.1.16"

  def project do
    [
      app: :electrum_client,
      version: @version,
      description: "Elixir library simplifying calls to an Electrum RPC Server",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "ElectrumClient",
      source_ref: @version,
      source_url: "https://github.com/RooSoft/electrum_client"
    ]
  end

  def package do
    [
      maintainers: ["Marc Lacoursière"],
      licenses: ["UNLICENCE"],
      links: %{"GitHub" => "https://github.com/RooSoft/electrum_client"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:jason, "~> 1.4"},
      {:bitcoinlib, "~> 0.3.2"}
    ]
  end
end
