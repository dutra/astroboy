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
    assert_in_delta latitude, 3.1059, 0.0001
  end
end
