defmodule Electrum do
  use GenServer

  alias Electrum.Calls.{GetBalance, ListUnspent}

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
    result = ListUnspent.call(socket, script_hash)

    {:reply, result, state}
  end

  def handle_call({:get_balance, script_hash}, _from, %{socket: socket} = state) do
    params = GetBalance.encode_params(script_hash)

    :ok = :gen_tcp.send(socket, params)

    result =
      receive do
        {:tcp, _socket, message} -> GetBalance.parse_result(message)
      end

    {:reply, result, state}
  end
end
