defmodule SunTest do
  use ExUnit.Case
  doctest Sun

  test "Sun position on 2003/07/27 00:00" do

    %Coordinates.Ecliptic{latitude: latitude, longitude: longitude} = Sun.get_position({{2003, 7, 27}, {0, 0, 0}})

    assert_in_delta latitude, 0, 0.0001
    assert_in_delta longitude, 2.15689, 0.0001

    jd = Julian.init({{2003, 7, 27}, {0, 0, 0}})
    %Coordinates.Equatorial{declination: declination, ra: ra} = Coordinates.to_equatorial(%Coordinates.Ecliptic{latitude: latitude, longitude: longitude}, jd)

    assert_in_delta declination, 0.338, 0.001
    assert_in_delta ra, 2.197, 0.001

  end

  test "Sun position on 2015/12/25 20:00" do
    c = Sun.get_position({{2015, 12, 25}, {20, 0, 0}})
    jd = Julian.init({{2015, 12, 25}, {20, 0, 0}})

    %Coordinates.Equatorial{declination: declination, ra: ra} = Coordinates.to_equatorial(c, jd)
    assert_in_delta declination, 5.875, 0.001
    assert_in_delta ra, 4.783, 0.001
  end
end
