# Electrum

Elixir library simplifying calls to an Electrum RPC Server

## Installation

```elixir
def deps do
  [
    {:electrum, "~> 0.1.0"}
  ]
end
```

## Example usage

Works both on `mainnet` or `testnet`, depends on the electrum server's configuration.

Example calling a `testnet` server at `192.168.1.10` on port `60001` to get a list of
UTXO from the `67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858` script hash.

```elixir
Electrum.start_link("192.168.1.10", 60001)
Electrum.list_unspent("67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858")
```

## Local configuration

It is possible ton configure your own electrum server automatically when iex starts.

Create a `.iex.local.exs` file containing the follwing contents, assuming your electrum
server is at `192.168.1.10`, answering to port `60001`:

```elixir
Electrum.start_link("192.168.1.10", 60001)
```

## Get a bitcoin address balance

Send an address to `get_balance` and get a number of confirmed and unconfirmed sats.

```elixir
Electrum.get_balance("mrEpoDtBXKwrudWUhRqnz3j1yuj7kKHw5p")
```

```elixir
%{confirmed: 1318882, unconfirmed: 0}
```

## List a bitcoin address UTXOs

To get a list of unspent transaction outputs related to an address, send the address
to `list_unspent`

```elixir
Electrum.get_balance("mrEpoDtBXKwrudWUhRqnz3j1yuj7kKHw5p")
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