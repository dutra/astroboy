defmodule MoonTest do
  use ExUnit.Case
  doctest Moon

  test "Moon position on 2003/09/01 00:00" do

    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}} = Moon.get_position({{2003, 9, 1}, {0, 0, 0}})

    assert_in_delta latitude, 0.02995, 0.0001
    assert_in_delta longitude, 3.75015, 0.0001

  end
end
