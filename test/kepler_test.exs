defmodule KeplerTest do
  use ExUnit.Case
  doctest Kepler

  test "greets the world" do
    assert Kepler.hello() == :world
  end
end
