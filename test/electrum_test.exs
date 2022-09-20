defmodule ElectrumTest do
  use ExUnit.Case
  doctest Electrum

  test "greets the world" do
    assert Electrum.hello() == :world
  end
end
