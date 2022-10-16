defmodule ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory do
  @moduledoc """
  Manages blockchain.scripthash.get_history params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-get-history
  """

  alias ElectrumClient.Address

  @doc """
  Calls the electrum server with the required parameters and returns a the script hash's history
  """
  def call(socket, address) do
    params =
      address
      |> Address.to_script_hash()
      |> encode_params

    :ok = :gen_tcp.send(socket, params)

    receive do
      {:tcp, _socket, message} -> parse_result(message)
    end
  end

  @doc """
  Converts a script hash into blockchain.scripthash.get_history params

  ## Examples
    iex> "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
    ...> |> ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.scripthash.get_history\",\"params\":[\"67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858\"]}
    \"""
  """
  def encode_params(script_hash) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.get_history",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Converts a blockchain.scripthash.get_history's call result into an elixir list

  ## Examples
    iex>  \"""
    ...>   {\"id\":1,\"jsonrpc\":\"2.0\",\"result\":[{\"height\":2347375,\"tx_hash\":\"dde058767aa566f2aba736320796771922efa6cb6e75f1cba3d47e4bfd5ae0d8\"},{\"height\":2347382,\"tx_hash\":\"5a957f4bff6d23140eb7e9b6fcedd41d3febf1e145d37519c593c939789a49af\"}]}
    ...>  \"""
    ...>  |> ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory.parse_result()
    [
      %{
        height: 2347375,
        txid: "dde058767aa566f2aba736320796771922efa6cb6e75f1cba3d47e4bfd5ae0d8"
      },
      %{
        height: 2347382,
        txid: "5a957f4bff6d23140eb7e9b6fcedd41d3febf1e145d37519c593c939789a49af"
      }
    ]
  """
  @spec parse_result(list()) :: [%{confirmed: integer(), unconfirmed: integer()}]
  def parse_result(message) do
    %{"result" => history} = Jason.decode!(message)

    history
    |> Enum.map(&parse_history_item/1)
  end

  defp parse_history_item(%{"height" => height, "tx_hash" => txid}) do
    %{
      height: height,
      txid: txid
    }
  end
end
