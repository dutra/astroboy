defmodule CoordinatesTest do
  use ExUnit.Case
  doctest Coordinates

  test "Ecliptic to Equatorial on July 6 2009" do
    ecliptic = %Coordinates.Ecliptic{latitude: 0.0850897, longitude: 2.4379826}
    jd = Julian.init({{2009, 7, 6}, {0, 0, 0}})
    %Coordinates.Equatorial{declination: declination, ra: ra} = Coordinates.to_equatorial(ecliptic, jd)
    assert_in_delta declination, 0.341, 0.001
    assert_in_delta ra, 2.508, 0.001
  end
end
