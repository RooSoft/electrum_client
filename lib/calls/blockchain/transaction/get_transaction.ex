defmodule ElectrumClient.Calls.Blockchain.Transaction.GetTransaction do
  alias BitcoinLib.Transaction

  @moduledoc """
  Manages blockchain.transaction.get params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-transaction-get
  """

  # @doc """
  # Calls the electrum server with the required parameters and returns a properly
  # parsed bitcoinlib transaction
  # """
  # ## TODO: can't typespec that function...
  # # @spec call(any(), any()) :: %Transaction{}
  # def call(socket, transaction_id) do
  #   params = encode_params(transaction_id)

  #   Endpoint.request(socket, params)
  # end

  @doc """
  Converts a transation id into blockchain.transaction.get params

  ## Examples
    iex> "05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373"
    ...> |> ElectrumClient.Calls.Blockchain.Transaction.GetTransaction.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.transaction.get\",\"params\":[\"05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373\",true]}
    \"""
  """
  def encode_params(transaction_id) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.transaction.get",
      params: [transaction_id, true]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Translates an electrum result into a transaction with some metadata

  ## Examples
      iex> %{
      ...>   "blockhash" => "00000000860832b294ccf5001b7758f1ca56877477a3f9ef7b56c6eea51b5cd2",
      ...>   "blocktime" => 1666631007,
      ...>   "confirmations" => 133,
      ...>   "hash" => "91d4cb0f40802a6855573e1c8dab2db9b8f47fbee53c003d69a7978ab6219535",
      ...>   "hex" => "02000000000101bcd97bf4167bee1504a0a7d913333829e84807eb080f1f250eb83d8f17ae3f740100000000feffffff02d491b1350200000016001412b346ad6745452f8ac377bddd7fdcc64391a9e156dc1b000000000016001430db5518552e3e91c29b1697747ddfe5186db4060247304402204060217580c8326a2c1ccaa1c5a9b3dfa2142ea141ab19e5bbb453679d93b696022041c9dd084afdff5de4717252ac22ab342efd2546ace76c83071f30ac10312097012102c0fecec2f64f82c34eadfee5757f28037338cbe0cdca6515bf611ff98179c4c319492400",
      ...>   "in_active_chain" => true,
      ...>   "locktime" => 2378009,
      ...>   "size" => 222,
      ...>   "time" => 1666631007,
      ...>   "txid" => "e58705f2c55c5ae5c08b2854964870a2dc9a8380886bfd993c8a6e4dbaa8cce6",
      ...>   "version" => 2,
      ...>   "vin" => [
      ...>     %{
      ...>       "scriptSig" => %{"asm" => "", "hex" => ""},
      ...>       "sequence" => 4294967294,
      ...>       "txid" => "743fae178f3db80e251f0f08eb0748e829383313d9a7a00415ee7b16f47bd9bc",
      ...>       "txinwitness" => ["304402204060217580c8326a2c1ccaa1c5a9b3dfa2142ea141ab19e5bbb453679d93b696022041c9dd084afdff5de4717252ac22ab342efd2546ace76c83071f30ac1031209701",
      ...>        "02c0fecec2f64f82c34eadfee5757f28037338cbe0cdca6515bf611ff98179c4c3"],
      ...>       "vout" => 1
      ...>     }
      ...>   ],
      ...>   "vout" => [
      ...>     %{
      ...>       "n" => 0,
      ...>       "scriptPubKey" => %{
      ...>         "address" => "tb1qz2e5dtt8g4zjlzkrw77a6l7uceper20p252njp",
      ...>         "asm" => "0 12b346ad6745452f8ac377bddd7fdcc64391a9e1",
      ...>         "desc" => "addr(tb1qz2e5dtt8g4zjlzkrw77a6l7uceper20p252njp)#rujqyznz",
      ...>         "hex" => "001412b346ad6745452f8ac377bddd7fdcc64391a9e1",
      ...>         "type" => "witness_v0_keyhash"
      ...>       },
      ...>       "value" => 94.90764244
      ...>     },
      ...>     %{
      ...>       "n" => 1,
      ...>       "scriptPubKey" => %{
      ...>         "address" => "tb1qxrd42xz49clfrs5mz6thglwlu5vxmdqxsvpnks",
      ...>         "asm" => "0 30db5518552e3e91c29b1697747ddfe5186db406",
      ...>         "desc" => "addr(tb1qxrd42xz49clfrs5mz6thglwlu5vxmdqxsvpnks)#46ddnv7x",
      ...>         "hex" => "001430db5518552e3e91c29b1697747ddfe5186db406",
      ...>         "type" => "witness_v0_keyhash"
      ...>       },
      ...>       "value" => 0.01825878
      ...>     }
      ...>   ],
      ...>   "vsize" => 141,
      ...>   "weight" => 561
      ...> }
      ...> |> ElectrumClient.Calls.Blockchain.Transaction.GetTransaction.translate()
      %{
        block_hash: "00000000860832b294ccf5001b7758f1ca56877477a3f9ef7b56c6eea51b5cd2",
        time: ~U[2022-10-24 17:03:27Z],
        confirmations: 133,
        vsize: 141,
        transaction: %BitcoinLib.Transaction{
          version: 2,
          id: "91d4cb0f40802a6855573e1c8dab2db9b8f47fbee53c003d69a7978ab6219535",
          inputs: [
            %BitcoinLib.Transaction.Input{
              txid: "743fae178f3db80e251f0f08eb0748e829383313d9a7a00415ee7b16f47bd9bc",
              vout: 1,
              script_sig: [],
              sequence: 4294967294
            }
          ],
          outputs: [
            %BitcoinLib.Transaction.Output{
              value: 9490764244,
              script_pub_key: [%BitcoinLib.Script.Opcodes.Constants.Zero{},
               %BitcoinLib.Script.Opcodes.Data{value: <<0x12b346ad6745452f8ac377bddd7fdcc64391a9e1::160>>}]
            },
            %BitcoinLib.Transaction.Output{
              value: 1825878,
              script_pub_key: [%BitcoinLib.Script.Opcodes.Constants.Zero{},
               %BitcoinLib.Script.Opcodes.Data{value: <<0x30db5518552e3e91c29b1697747ddfe5186db406::160>>}]
            }
          ],
          locktime: 2378009,
          witness: [<<0x02c0fecec2f64f82c34eadfee5757f28037338cbe0cdca6515bf611ff98179c4c3::264>>,
           <<0x304402204060217580c8326a2c1ccaa1c5a9b3dfa2142ea141ab19e5bbb453679d93b696022041c9dd084afdff5de4717252ac22ab342efd2546ace76c83071f30ac1031209701::568>>]
        }
      }
  """
  def translate(%{
        "blockhash" => block_hash,
        "blocktime" => block_time,
        "confirmations" => confirmations,
        "hex" => hex,
        "vsize" => vsize
      }) do
    %{
      block_hash: block_hash,
      time: DateTime.from_unix!(block_time),
      confirmations: confirmations,
      vsize: vsize,
      transaction: Transaction.parse(hex) |> elem(1)
    }
  end
end
