# ElectrumClient

Elixir library simplifying calls to an Electrum RPC Server

## Installation

```elixir
def deps do
  [
    {:electrum_client, "~> 0.1.4"}
  ]
end
```

## Example usage

Works both on `mainnet` or `testnet`, depends on the electrum server's configuration.

Example calling a `testnet` server at `192.168.1.10` on port `60001` to get a list of
UTXO from the `67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858` script hash.

```elixir
ElectrumClient.start_link("192.168.1.10", 60001)
ElectrumClient.list_unspent("67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858")
```

## Local configuration

It is possible ton configure your own electrum server automatically when iex starts.

Create a `.iex.local.exs` file containing the follwing contents, assuming your electrum
server is at `192.168.1.10`, answering to port `60001`:

```elixir
ElectrumClient.start_link("192.168.1.10", 60001)
```

## Get a bitcoin address balance

Send an address to `get_balance` and get a number of confirmed and unconfirmed sats

```elixir
ElectrumClient.get_balance("mrEpoDtBXKwrudWUhRqnz3j1yuj7kKHw5p")
```

```elixir
%{confirmed: 1318882, unconfirmed: 0}
```

## List a bitcoin address UTXOs

To get a list of unspent transaction outputs related to an address, send the address
to `list_unspent`

```elixir
ElectrumClient.list_unspent("mrEpoDtBXKwrudWUhRqnz3j1yuj7kKHw5p")
```

```elixir
[
  %{
    height: 2347375,
    transaction_id: "dde058767aa566f2aba736320796771922efa6cb6e75f1cba3d47e4bfd5ae0d8",
    value: 1318882,
    vxid: 1
  }
]
```

## Broadcast a transaction

Send an encoded transaction to `broadcast_transaction` and you'll get a transaction id back

```elixir
ElectrumClient.broadcast_transaction("0100000001fa80e26e6427d965b670963747b8103226f40af76d358e47a53217db208fafc8010000006a47304402203234d17d3f6f132b81410d6a8c481912bc650c6dcb31d9a4a34d2ac0f6506e28022026146c17ba95b2c2719a2b4879a35dbbfcbd5144aecb3ff1a9a3cfc7894ae392012103ea1c6a4e250bc539f950c29f083f5e93aa0bf5d4a344af36a356ad4cf8a3ad2cffffffff02f0ff3700000000001976a9140afcad5c79123211ad61bd4723e1b23e9480f1c788ac10270000000000001976a9140fe85c1741be269c77f21c3a0386b8a2fb84ff8388ac00000000")
```

```elixir
{:ok, "ba9e74b6359c5ff49bb5a1dc0979ce85db8ee45aa90fbf170ff72dec0aad542f"}
```

## Get a transaction's details

Send a transaction id to `get_transaction` to get a map containing all the transaction's details

```elixir
ElectrumClient.get_transaction "05517750a78fb8c38346b1bf5908d71abe728811b643105be6595e11a9392373"
```

```elixir
%BitcoinLib.Transaction{
  version: 1,
  inputs: [
    %BitcoinLib.Transaction.Input{
      txid: "420c552d7821da5da61be91dffe984537f460dc668f0766f6c2e1c7a10287610",
      vout: 0,
      script_sig: [%BitcoinLib.Script.Opcodes.Data{value: <<0x30440220571a1484112982604f16f2d1a49c862e2093cedfaf3042af42d7b587c220fbff022055435f538623f09572b87770cf93d7183d1bcb7503895682672f8f98134b320e01::568>>},
       %BitcoinLib.Script.Opcodes.Data{value: <<0x02f942091e070d59e2f86e17b77e4f96539752f19f360dbf87ef15ea1f0fe8a4e2::264>>}],
      sequence: 4294967295
    }
  ],
  outputs: [
    %BitcoinLib.Transaction.Output{
      value: 4000,
      script_pub_key: [%BitcoinLib.Script.Opcodes.Stack.Dup{},
       %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
       %BitcoinLib.Script.Opcodes.Data{value: <<0x09d6cbc4a478c8f1cbde9085b10fb84519591afb::160>>},
       %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
       %BitcoinLib.Script.Opcodes.Crypto.CheckSig{script: <<0x76a91409d6cbc4a478c8f1cbde9085b10fb84519591afb88ac::200>>}]
    },
    %BitcoinLib.Transaction.Output{
      value: 5000,
      script_pub_key: [%BitcoinLib.Script.Opcodes.Stack.Dup{},
       %BitcoinLib.Script.Opcodes.Crypto.Hash160{},
       %BitcoinLib.Script.Opcodes.Data{value: <<0xe8046c97f9c1c38ff6c15e4d7696385309d54388::160>>},
       %BitcoinLib.Script.Opcodes.BitwiseLogic.EqualVerify{},
       %BitcoinLib.Script.Opcodes.Crypto.CheckSig{script: <<0x76a914e8046c97f9c1c38ff6c15e4d7696385309d5438888ac::200>>}]
    }
  ],
  locktime: 0
}
```