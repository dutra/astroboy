defmodule PlanetTest do
  use ExUnit.Case
  doctest Planet

  test "Jupiter position on 2003/11/22 00:00" do
    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}} = Planet.get_position(date: {{2003, 11, 22}, {0, 0, 0}}, planet: :jupiter)

    assert_in_delta longitude, 2.90267, 0.0001
    assert_in_delta latitude, 0.01809, 0.0001
  end

  test "Mercury position on 2003/11/22 00:00" do
    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}} = Planet.get_position(date: {{2003, 11, 22}, {0, 0, 0}}, planet: :mercury)

    assert_in_delta longitude, 4.4319103, 0.0001
    assert_in_delta latitude, -0.03567, 0.0001
  end

  test "Neptune position on 2015/10/20 00:00" do
    ecliptic_coords = Planet.get_position(date: {{2015, 10, 20}, {0, 0, 0}}, planet: :neptune)


    %Coordinates.Equatorial{declination: %Angle{radians: declination},
                            ra: %Angle{radians: ra}} = Coordinates.to_equatorial(ecliptic_coords, Julian.init({{2015, 10, 20}, {0, 0, 0}}))


    assert_in_delta declination, -0.1679, 0.0001
    assert_in_delta ra, 5.9206, 0.0001


  end
end
