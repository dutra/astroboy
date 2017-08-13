defmodule CoordinatesTest do
  use ExUnit.Case
  doctest Coordinates

  test "Ecliptic to Equatorial on July 6 2009" do
    ecliptic = %Coordinates.Ecliptic{latitude: %Angle{radians: 0.0850897},
                                     longitude: %Angle{radians: 2.4379826}}

    jd = Julian.init({{2009, 7, 6}, {0, 0, 0}})

    %Coordinates.Equatorial{declination: %Angle{radians: declination},
                            ra: %Angle{radians: ra}} = Coordinates.to_equatorial(ecliptic, jd)
    assert_in_delta declination, 0.341, 0.001
    assert_in_delta ra, 2.508, 0.001
  end

  test "Equatorial to Ecliptic on July 6 2009" do
    equatorial = %Coordinates.Equatorial{declination: %Angle{radians: 0.3409501178584604},
                                         ra: %Angle{radians: 2.5084250164333772}}
    jd = Julian.init({{2009, 7, 6}, {0, 0, 0}})

    %Coordinates.Ecliptic{longitude: %Angle{radians: longitude},
                          latitude: %Angle{radians: latitude}} = Coordinates.to_ecliptic(equatorial, jd)

    assert_in_delta longitude, 2.4379, 0.001
    assert_in_delta latitude, 0.0851, 0.001
  end
end
