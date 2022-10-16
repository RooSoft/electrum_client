defmodule ElectrumClient.Address do
  @moduledoc """
  Address manipulation utilities
  """

  alias BitcoinLib.Crypto
  alias BitcoinLib.Key.{PublicKeyHash}

  @doc """
  Converts an address to a script hash, which is required in almost every Electrum call

  ## Examples
    iex> "mgQyh4nYjr47S1W4Wy1PgFCrN38GfVyZdp"
    ...> |> ElectrumClient.Address.to_script_hash
    "67a5662abf889b5a28ffa821c1f85fd3ef9313756b881351d91a3671f3f52858"
  """
  def to_script_hash(address) do
    address
    |> address_to_public_key_hash
    |> public_key_hash_to_script
    |> hash_script
  end

  defp address_to_public_key_hash(address) do
    {:ok, public_key_hash, _format} =
      address
      |> PublicKeyHash.from_address()

    public_key_hash
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
