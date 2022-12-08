defmodule ElectrumClient.Calls.Blockchain.Transaction.GetTransactionTest do
  use ExUnit.Case, async: true
#  alias ElectrumClient.Calls.Blockchain.Transaction.GetTransaction

  ## TODO: this test is broken and hard to maintain,
  ## find a way to split it into smaller parts
  #
  # describe "translate" do
  #   test "PSBT" do
  #     assert %{
  #              block_hash: nil,
  #              confirmations: 0,
  #              time: nil,
  #              transaction: %BitcoinLib.Transaction{
  #                version: 2,
  #                id: "97b6e12a670ea61cb5e397af1f7049f6b8b39318506bb9e4e2c5c3f2e0b1b035",
  #                inputs: [
  #                  %BitcoinLib.Transaction.Input{
  #                    txid: "e445e3dd9828dd61b2b5ae144205d7038d8fb9ab1cb991f5a1bc6b387660ba81",
  #                    vout: 0,
  #                    script_sig: [],
  #                    sequence: 4_294_967_293
  #                  }
  #                ],
  #                outputs: [
  #                  %BitcoinLib.Transaction.Output{
  #                    value: 9600,
  #                    script_pub_key: [
  #                      %BitcoinLib.Script.Opcodes.Constants.Zero{},
  #                      %BitcoinLib.Script.Opcodes.Data{
  #                        value: <<0xC42F70622098963F94806BDA40DE0E0590EB7578::160>>
  #                      }
  #                    ]
  #                  },
  #                  %BitcoinLib.Transaction.Output{
  #                    value: 20000,
  #                    script_pub_key: [
  #                      %BitcoinLib.Script.Opcodes.Constants.Zero{},
  #                      %BitcoinLib.Script.Opcodes.Data{
  #                        value: <<0x3174A3815C62F3DE96C52A8613F260DE6A7358F3::160>>
  #                      }
  #                    ]
  #                  }
  #                ],
  #                locktime: 762_634,
  #                segwit?: true,
  #                witness: [
  #                  <<0x304402204770B9178D6596C4D4A5FE6993FB14166E0209689888D937C61EE3317FFBBAE5022022886DBF336ADF0D9FBB52EB11F0947216E13CA578909B047E3FDFE6C043365801::568>>,
  #                  <<0x028DBAD32A4404EE120627AB7E46A3E3F12B4939BFD9AEBE78F81D0420CF64EFF3::264>>
  #                ]
  #              },
  #              vsize: 141
  #            } == GetTransaction.translate(sample_psbt())
  #   end
  # end

  # defp sample_psbt() do
  #   %{
  #     "hash" => "980a18154907ca3e6353b277d960ab07752574655d1fd28663446c2f341779c5",
  #     "hex" =>
  #       "0200000000010181ba6076386bbca1f591b91cabb98f8d03d7054214aeb5b261dd2898dde345e40000000000fdffffff028025000000000000160014c42f70622098963f94806bda40de0e0590eb7578204e0000000000001600143174a3815c62f3de96c52a8613f260de6a7358f30247304402204770b9178d6596c4d4a5fe6993fb14166e0209689888d937c61ee3317ffbbae5022022886dbf336adf0d9fbb52eb11f0947216e13ca578909b047e3fdfe6c04336580121028dbad32a4404ee120627ab7e46a3e3f12b4939bfd9aebe78f81d0420cf64eff30aa30b00",
  #     "locktime" => 762_634,
  #     "size" => 222,
  #     "txid" => "97b6e12a670ea61cb5e397af1f7049f6b8b39318506bb9e4e2c5c3f2e0b1b035",
  #     "version" => 2,
  #     "vin" => [
  #       %{
  #         "scriptSig" => %{"asm" => "", "hex" => ""},
  #         "sequence" => 4_294_967_293,
  #         "txid" => "e445e3dd9828dd61b2b5ae144205d7038d8fb9ab1cb991f5a1bc6b387660ba81",
  #         "txinwitness" => [
  #           "304402204770b9178d6596c4d4a5fe6993fb14166e0209689888d937c61ee3317ffbbae5022022886dbf336adf0d9fbb52eb11f0947216e13ca578909b047e3fdfe6c043365801",
  #           "028dbad32a4404ee120627ab7e46a3e3f12b4939bfd9aebe78f81d0420cf64eff3"
  #         ],
  #         "vout" => 0
  #       }
  #     ],
  #     "vout" => [
  #       %{
  #         "n" => 0,
  #         "scriptPubKey" => %{
  #           "address" => "bc1qcshhqc3qnztrl9yqd0dyphswqkgwkatcnetctm",
  #           "asm" => "0 c42f70622098963f94806bda40de0e0590eb7578",
  #           "desc" => "addr(bc1qcshhqc3qnztrl9yqd0dyphswqkgwkatcnetctm)#v98xl8lz",
  #           "hex" => "0014c42f70622098963f94806bda40de0e0590eb7578",
  #           "type" => "witness_v0_keyhash"
  #         },
  #         "value" => 9.6e-5
  #       },
  #       %{
  #         "n" => 1,
  #         "scriptPubKey" => %{
  #           "address" => "bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq",
  #           "asm" => "0 3174a3815c62f3de96c52a8613f260de6a7358f3",
  #           "desc" => "addr(bc1qx9628q2uvteaa9k992rp8unqme48xk8n7x0fjq)#d9vpz889",
  #           "hex" => "00143174a3815c62f3de96c52a8613f260de6a7358f3",
  #           "type" => "witness_v0_keyhash"
  #         },
  #         "value" => 0.0002
  #       }
  #     ],
  #     "vsize" => 141,
  #     "weight" => 561
  #   }
  # end
end
