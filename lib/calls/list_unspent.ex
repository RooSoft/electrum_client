defmodule Electrum.Calls.ListUnspent do
  @moduledoc """
  Manages output from blockchain.scripthash.listunspent calls

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-listunspent
  """

  @doc """
  Converts a blockchain.scripthash.listunspent's call result into an elixir list

  ## Examples
    iex>  \"""
    ...>   {\"id\":1,\"jsonrpc\":\"2.0\",\"result\":[{\"height\":2346430,\"tx_hash\":\"05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373\",\"tx_pos\":0,\"value\":4000}]}
    ...>  \"""
    ...>  |> Electrum.Calls.ListUnspent.parse()
    [
      %{
        height: 2346430,
        transaction_id: "05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373",
        value: 4000,
        vxid: 0
      }
    ]
  """
  @spec parse(list()) :: list()
  def parse(message) do
    %{"result" => utxo_list} = Jason.decode!(message)

    utxo_list
    |> convert_utxo_list
  end

  defp convert_utxo_list(utxo_list) do
    utxo_list
    |> Enum.map(&convert_utxo/1)
  end

  defp convert_utxo(%{
         "height" => height,
         "tx_pos" => vxid,
         "tx_hash" => transaction_id,
         "value" => value
       }) do
    %{
      height: height,
      vxid: vxid,
      transaction_id: transaction_id,
      value: value
    }
  end
end
