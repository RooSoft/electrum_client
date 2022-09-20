defmodule Electrum.Calls.GetBalance do
  @moduledoc """
  Manages blockchain.scripthash.get_balance params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-get-balance
  """

  @doc """
  Converts a script hash into blockchain.scripthash.get_balance params

  ## Examples
    iex> "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
    ...> |> Electrum.Calls.GetBalance.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.scripthash.get_balance\",\"params\":[\"67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858\"]}
    \"""
  """
  def encode_params(script_hash) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.get_balance",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Converts a blockchain.scripthash.get_balance's call result into an elixir list

  ## Examples
    iex>  \"""
    ...>   {\"id\":1,\"jsonrpc\":\"2.0\",\"result\":{\"confirmed\":4000,\"unconfirmed\":0}}
    ...>  \"""
    ...>  |> Electrum.Calls.GetBalance.parse_result()
    %{confirmed: 4000, unconfirmed: 0}
  """
  @spec parse_result(list()) :: list()
  def parse_result(message) do
    %{"result" => balance} = Jason.decode!(message)

    balance
    |> convert_balance
  end

  defp convert_balance(%{
         "confirmed" => confirmed,
         "unconfirmed" => unconfirmed
       }) do
    %{
      confirmed: confirmed,
      unconfirmed: unconfirmed
    }
  end
end
