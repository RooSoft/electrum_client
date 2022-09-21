defmodule Electrum do
  use GenServer

  alias Electrum.Calls.Blockchain.ScriptHash.{GetBalance, ListUnspent}
  alias Electrum.Calls.Blockchain.Transaction.{GetTransaction}

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

  def get_balance(address) do
    GenServer.call(__MODULE__, {:get_balance, address})
  end

  def list_unspent(address) do
    GenServer.call(__MODULE__, {:list_unspent, address})
  end

  def get_transaction(transaction_id) do
    GenServer.call(__MODULE__, {:get_transaction, transaction_id})
  end

  def handle_call({:list_unspent, address}, _from, %{socket: socket} = state) do
    result = ListUnspent.call(socket, address)

    {:reply, result, state}
  end

  def handle_call({:get_balance, address}, _from, %{socket: socket} = state) do
    result = GetBalance.call(socket, address)

    {:reply, result, state}
  end

  def handle_call({:get_transaction, transaction_id}, _from, %{socket: socket} = state) do
    result = GetTransaction.call(socket, transaction_id)

    {:reply, result, state}
  end
end
