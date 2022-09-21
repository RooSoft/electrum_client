defmodule Electrum.Calls.Blockchain.Transaction.GetTransaction do
  @moduledoc """
  Manages blockchain.transaction.get params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-transaction-get
  """

  alias BitcoinLib.Transaction

  @doc """
  Calls the electrum server with the required parameters and returns a properly
  parsed bitcoinlib transaction
  """
  @spec call(any(), binary()) :: %BitcoinLib.Transaction{}
  def call(socket, transaction_id) do
    params = encode_params(transaction_id)

    :ok = :gen_tcp.send(socket, params)

    receive do
      {:tcp, _socket, message} -> parse_result(message)
    end
  end

  @doc """
  Converts a transation id into blockchain.transaction.get params

  ## Examples
    iex> "05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373"
    ...> |> Electrum.Calls.Blockchain.Transaction.GetTransaction.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.transaction.get\",\"params\":[\"05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373\"]}
    \"""
  """
  def encode_params(transaction_id) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.transaction.get",
      params: [transaction_id]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Converts a blockchain.transaction.get's call result into a %BitcoinLib.Transaction{}

  ## Examples
    iex>  \"""
    ...>   {\"id\":1,\"jsonrpc\":\"2.0\",\"result\":\"0100000001107628107a1c2e6c6f76f068c60d467f5384e9ff1de91ba65dda21782d550c42000000006a4730440220571a1484112982604f16f2d1a49c862e2093cedfaf3042af42d7b587c220fbff022055435f538623f09572b87770cf93d7183d1bcb7503895682672f8f98134b320e012102f942091e070d59e2f86e17b77e4f96539752f19f360dbf87ef15ea1f0fe8a4e2ffffffff02a00f0000000000001976a91409d6cbc4a478c8f1cbde9085b10fb84519591afb88ac88130000000000001976a914e8046c97f9c1c38ff6c15e4d7696385309d5438888ac00000000\"}
    ...>  \"""
    ...>  |> Electrum.Calls.Blockchain.Transaction.GetTransaction.parse_result()
    %BitcoinLib.Transaction{
      version: 1,
      inputs: [
        %BitcoinLib.Transaction.Input{
          txid: "420c552d7821da5da61be91dffe984537f460dc668f0766f6c2e1c7a10287610",
          vout: 0,
          script_sig: [
            %BitcoinLib.Script.Opcodes.Data{value: <<0x30440220571a1484112982604f16f2d1a49c862e2093cedfaf3042af42d7b587c220fbff022055435f538623f09572b87770cf93d7183d1bcb7503895682672f8f98134b320e01::568>>},
            %BitcoinLib.Script.Opcodes.Data{value: <<0x02f942091e070d59e2f86e17b77e4f96539752f19f360dbf87ef15ea1f0fe8a4e2::264>>}
          ],
          sequence: 4294967295
        }
      ],
      outputs: [
        %BitcoinLib.Transaction.Output{
          value: 4000,
          script_pub_key: [
            %BitcoinLib.Script.Opcodes.Stack.Dup{},
            %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
            %BitcoinLib.Script.Opcodes.Data{value: <<0x09d6cbc4a478c8f1cbde9085b10fb84519591afb::160>>},
            %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
            %BitcoinLib.Script.Opcodes.Crypto.CheckSig{script: <<0x76a91409d6cbc4a478c8f1cbde9085b10fb84519591afb88ac::200>>}
          ]
        },
        %BitcoinLib.Transaction.Output{
          value: 5000,
          script_pub_key: [
            %BitcoinLib.Script.Opcodes.Stack.Dup{},
            %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
            %BitcoinLib.Script.Opcodes.Data{value: <<0xe8046c97f9c1c38ff6c15e4d7696385309d54388::160>>},
            %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
            %BitcoinLib.Script.Opcodes.Crypto.CheckSig{script: <<0x76a914e8046c97f9c1c38ff6c15e4d7696385309d5438888ac::200>>}
          ]
        }
      ],
      locktime: 0
    }
  """
  @spec parse_result(list()) :: %Transaction{}
  def parse_result(message) do
    %{"result" => transaction} = Jason.decode!(message)

    {:ok, transaction} = Transaction.parse(transaction)

    transaction
  end
end
