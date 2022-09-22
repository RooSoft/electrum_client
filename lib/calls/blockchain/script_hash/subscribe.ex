defmodule Electrum.Calls.Blockchain.ScriptHash.Subscribe do
  @moduledoc """
  Manages blockchain.scripthash.subscribe params and results

  ref: https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-methods.html#blockchain-scripthash-subscribe
  """

  alias Electrum.Address

  @doc """
  Calls the electrum server with the required parameters to start a subscription to an address's events
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
  Converts a script hash into blockchain.scripthash.subscribe params

  ## Examples
    iex> "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
    ...> |> Electrum.Calls.Blockchain.ScriptHash.Subscribe.encode_params()
    \"""
    {\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"blockchain.scripthash.subscribe\",\"params\":[\"67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858\"]}
    \"""
  """
  def encode_params(script_hash) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.subscribe",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    "#{encoded}\n"
  end

  @doc """
  Converts a blockchain.scripthash.subscribe's call result into an elixir list

  ## Examples
    iex>  \"""
    ...>   {\"id\":1,\"jsonrpc\":\"2.0\",\"result\":\"3d638df1f781871c98b2f334f1d0af592f88d972d3e7742100dd644592436b5f\"}
    ...>  \"""
    ...>  |> Electrum.Calls.Blockchain.ScriptHash.Subscribe.parse_result()
    "3d638df1f781871c98b2f334f1d0af592f88d972d3e7742100dd644592436b5f"
  """
  @spec parse_result(list()) :: %{confirmed: integer(), unconfirmed: integer()}
  def parse_result(message) do
    %{"result" => result} = Jason.decode!(message)

    result
  end

  def interpret_event(params) do
    params
  end
end
