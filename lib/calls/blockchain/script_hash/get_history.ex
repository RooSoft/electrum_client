defmodule ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory do
  alias ElectrumClient.Address

  @moduledoc """
  Manages blockchain.scripthash.get_history params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-get-history
  """

  @doc """
  Converts a script hash into blockchain.scripthash.get_history params

  ## Examples
      iex> "tb1qqu0x5hfjktz5azefaaa0937w0692ln0dvanfu8"
      ...> |> ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory.encode_params()
      \"""
      {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.scripthash.get_history\",\"params\":[\"295634380c67a76e8138f3e61c616b8d0d5ca2362b2ede17de0080d879bd21c8\\"]}
      \"""
  """
  def encode_params(address) do
    script_hash = Address.to_script_hash(address)

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
      iex> [
      ...>   %{ "height" => 2347375, "tx_hash" => "dde058767aa566f2aba736320796771922efa6cb6e75f1cba3d47e4bfd5ae0d8" },
      ...>   %{ "height" => 2347382, "tx_hash" => "5a957f4bff6d23140eb7e9b6fcedd41d3febf1e145d37519c593c939789a49af" }
      ...> ]
      ...> |> ElectrumClient.Calls.Blockchain.ScriptHash.GetHistory.translate()
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
  @spec translate(list()) :: [%{confirmed: integer(), unconfirmed: integer()}]
  def translate(history) do
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
