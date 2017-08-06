defmodule AstroboyTest do
  use ExUnit.Case
  doctest Astroboy

  test "greets the world" do
    assert Astroboy.hello() == :world
  end
end
