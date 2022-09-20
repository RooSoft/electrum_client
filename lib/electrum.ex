defmodule Electrum do
  use GenServer

  def start_link(electrum_ip, electrum_port) do
    GenServer.start_link(__MODULE__, %{electrum_ip: electrum_ip, electrum_port: electrum_port},
      name: __MODULE__
    )
  end

  def init(%{electrum_ip: electrum_ip, electrum_port: electrum_port} = state) do
    {:ok, socket} = :gen_tcp.connect(to_charlist(electrum_ip), electrum_port, [:binary])

    state =
      state
      |> Map.put(:socket, socket)

    {:ok, state}
  end

  def get_balance(script_hash) do
    GenServer.call(__MODULE__, {:get_balance, script_hash})
  end

  def list_unspent(script_hash) do
    GenServer.call(__MODULE__, {:list_unspent, script_hash})
  end

  def handle_call({:list_unspent, script_hash}, _from, %{socket: socket} = state) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.listunspent",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    serialized = "#{encoded}\n"

    :ok = :gen_tcp.send(socket, serialized)

    result =
      receive do
        {:tcp, _socket, message} -> parse_list_unspent(message)
      end

    {:reply, result, state}
  end

  def handle_call({:get_balance, script_hash}, _from, %{socket: socket} = state) do
    data = %{
      jsonrpc: "2.0",
      id: 1,
      method: "blockchain.scripthash.get_balance",
      params: [script_hash]
    }

    encoded = Jason.encode!(data)
    serialized = "#{encoded}\n"

    :ok = :gen_tcp.send(socket, serialized)

    result =
      receive do
        {:tcp, _socket, message} -> parse_balance(message)
      end

    {:reply, result, state}
  end

  defp parse_balance(message) do
    %{
      "id" => _id,
      "result" => %{
        "confirmed" => confirmed,
        "unconfirmed" => unconfirmed
      }
    } = Jason.decode!(message)

    %{
      confirmed: confirmed,
      unconfirmed: unconfirmed
    }
  end

  defp parse_list_unspent(message) do
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
         "tx_hash" => transaction_id,
         "tx_pos" => vxid,
         "value" => value
       }) do
    %{
      height: height,
      transaction_id: transaction_id,
      vxid: vxid,
      value: value
    }
  end
end
