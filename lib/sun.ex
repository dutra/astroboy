defmodule Sun do
  # values for 2010 epoch
  @ecliptic_longitude 4.8791937
  @ecliptic_longitude_perigee 4.9412442
  @orbit_eccentricity 0.016_705
  @semi_major_axis 1.495985E8
  @angular_diameter_at_r0 0.0093048

  def get_position({{year, month, day}, {hour, minute, second}}) do
    %Epoch{day: day} = Epoch.init({{year, month, day}, {hour, minute, second}})
    mean_anomaly = 2*:math.pi/365.242_191*day + @ecliptic_longitude - @ecliptic_longitude_perigee

    true_anomaly = mean_anomaly + 2*@orbit_eccentricity*:math.sin(mean_anomaly)
    ecliptic_longitude = true_anomaly + @ecliptic_longitude_perigee
    n = abs(trunc(ecliptic_longitude/(2*:math.pi))) + 1
    ecliptic_longitude = :math.fmod(ecliptic_longitude + n*2*:math.pi, 2*:math.pi)
    ecliptic_latitude = 0

    %Coordinates.Ecliptic{latitude: ecliptic_latitude,
                          longitude: ecliptic_longitude}

  end
end
