defmodule RbTest do
  use ExUnit.Case
  doctest Rb

  test "greets the world" do
    assert Rb.hello() == :world
  end
end
