defmodule ElectrumClient.Address do
  @moduledoc """
  Address manipulation utilities
  """

  alias BitcoinLib.Crypto
  alias BitcoinLib.Key.Address

  @doc """
  Converts an address to a script hash, which is required in almost every Electrum call

  ## Examples
    iex> "mgQyh4nYjr47S1W4Wy1PgFCrN38GfVyZdp"
    ...> |> ElectrumClient.Address.to_script_hash
    "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
  """
  def to_script_hash(address) do
    case Address.destructure(address) do
      {:ok, public_key_hash, :p2pkh, _network} ->
        p2pkh_to_script_hash(public_key_hash)

      {:ok, script_hash, :p2sh, _network} ->
        p2sh_to_script_hash(script_hash)

      {:ok, script_hash, :p2wpkh, _network} ->
        p2wpkh_to_script_hash(script_hash)

      _ ->
        raise "Unknown address type"
    end
  end

  defp p2pkh_to_script_hash(public_key_hash) do
    public_key_hash
    |> public_key_hash_to_script
    |> hash_script
  end

  defp p2sh_to_script_hash(script_hash) do
    script_hash
    |> public_script_hash_to_script
    |> hash_script
  end

  defp p2wpkh_to_script_hash(script_hash) do
    script_hash
    |> public_witness_script_hash_to_script
    |> hash_script
  end

  defp public_script_hash_to_script(script_hash) do
    {_, script} =
      script_hash
      |> BitcoinLib.Script.Types.P2sh.create()
      |> BitcoinLib.Script.encode()

    script
  end

  defp public_witness_script_hash_to_script(script_hash) do
    {_, script} =
      script_hash
      |> BitcoinLib.Script.Types.P2wpkh.create()
      |> BitcoinLib.Script.encode()

    script
  end

  defp public_key_hash_to_script(public_key_hash) do
    {_, script} =
      public_key_hash
      |> BitcoinLib.Script.Types.P2pkh.create()
      |> BitcoinLib.Script.encode()

    script
  end

  defp hash_script(script) do
    script
    |> Crypto.sha256()
    |> reverse_bitstring
    |> Binary.to_hex()
  end

  defp reverse_bitstring(bitstring) do
    bitstring
    |> :binary.bin_to_list()
    |> Enum.reverse()
    |> :binary.list_to_bin()
  end
end
