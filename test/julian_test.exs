defmodule JulianTest do
  use ExUnit.Case
  doctest Julian

  test "Julian days on June 19 2009 at 6 pm" do
    jd = Julian.init({{2009, 6, 19}, {18, 0, 0}})
    assert jd == %Julian{day: 2_455_002.25}
  end

  test "Julian days on July 6 2009" do
    jd = Julian.init({{2009, 7, 6}, {0, 0, 0}})
    assert jd == %Julian{day: 2_455_018.5}
  end

end
