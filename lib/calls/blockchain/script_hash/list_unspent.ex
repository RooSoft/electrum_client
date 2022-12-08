defmodule ElectrumClient.Calls.Blockchain.ScriptHash.ListUnspent do
  @moduledoc """
  Manages blockchain.scripthash.listunspent params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-listunspent
  """

  alias ElectrumClient.Address

  @doc """
  Calls the electrum server with the required parameters and returns a list of
  UTXO in the form of an elixir list
  """
  @spec call(any(), binary()) :: list()
  def call(socket, address) do
    params =
      address
      |> Address.to_script_hash()
      |> encode_params()

    :ok = :gen_tcp.send(socket, params)

    receive do
      {:tcp, _socket, message} -> translate(message)
    end
  end

  @doc """
  Converts a script hash into blockchain.scripthash.listunspent params

  ## Examples
    iex> "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
    ...> |> ElectrumClient.Calls.Blockchain.ScriptHash.ListUnspent.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.scripthash.listunspent\",\"params\":[\"67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858\"]}
    \"""
  """
  def encode_params(script_hash) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.listunspent",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Converts a blockchain.scripthash.listunspent's call result into an elixir list

  ## Examples
    iex>  \"""
    ...>  [{\"height\":2346430,\"tx_hash\":\"05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373\",\"tx_pos\":0,\"value\":4000}]
    ...>  \"""
    ...>  |> Jason.decode!()
    ...>
    ...>  |> ElectrumClient.Calls.Blockchain.ScriptHash.ListUnspent.translate()
    [
      %{
        height: 2346430,
        transaction_id: "05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373",
        value: 4000,
        vxid: 0
      }
    ]
  """
  @spec translate(list()) :: list()
  def translate(message) do
    message
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
