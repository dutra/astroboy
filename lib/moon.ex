defmodule Moon do

  # values for 2010 epoch

  @sun_ecliptic_longitude 4.8791937
  @sun_ecliptic_longitude_perigee 4.9412442
  @sun_orbit_eccentricity 0.016_705

  @mean_longitude_epoch 1.6044696 # radians
  @mean_longitude_perigee 2.2714252 # radians
  @mean_longitude_ascending_node_epoch 5.0908208 # radians
  @inclination_orbit 0.0898041 # radians
  @eccentricity_orbit 0.0549 # radians
  @semi_major_axis 384_401 # km
  @angular_diameter 0.5181 # degrees
  @parallax 0.9507 # degrees


  def get_position({{year, month, day}, {hour, minute, second}}) do
    %Epoch{day: day} = Epoch.init({{year, month, day}, {hour, minute, second}})

    # sun
    sun_mean_anomaly = 2*:math.pi/365.242_191*day + @sun_ecliptic_longitude - @sun_ecliptic_longitude_perigee
    sun_true_anomaly = sun_mean_anomaly + 2*@sun_orbit_eccentricity*:math.sin(sun_mean_anomaly)
    sun_ecliptic_longitude = sun_true_anomaly + @sun_ecliptic_longitude_perigee

    # moon
    mean_longitude = 2*:math.pi / 360.0 * 13.1763966*day + @mean_longitude_epoch
    mean_anomaly = mean_longitude - 2*:math.pi / 360.0 * 0.1114041 * day - @mean_longitude_perigee
    ascending_node_mean_longitude = @mean_longitude_ascending_node_epoch - 2*:math.pi / 360.0 * 0.0529539 * day

    evection_correction = 2*:math.pi / 360.0 * 1.2739 * :math.sin(2*(mean_longitude - sun_ecliptic_longitude) - mean_anomaly)

    annual_equation = 2*:math.pi / 360.0 * 0.1858 * :math.sin(sun_mean_anomaly)
    third_correction = 2*:math.pi / 360.0 * 0.37 * :math.sin(sun_mean_anomaly)

    corrected_anomaly = mean_anomaly + evection_correction - annual_equation - third_correction

    equation_centre =  2*:math.pi / 360.0 * 6.2886 * :math.sin(corrected_anomaly)

    forth_correction = 2*:math.pi / 360.0 * 0.214 * :math.sin(2*corrected_anomaly)

    corrected_longitude = mean_longitude + evection_correction + equation_centre - annual_equation + forth_correction

    variation = 2*:math.pi / 360.0 * 0.6583 * :math.sin(2*(corrected_longitude - sun_ecliptic_longitude))

    true_orbital_longitude = corrected_longitude + variation

    ascending_node_corrected_longitude = ascending_node_mean_longitude - 2*:math.pi / 360.0 * 0.16*:math.sin(sun_mean_anomaly)

    longitude = :math.atan2(:math.sin(true_orbital_longitude - ascending_node_corrected_longitude)*:math.cos(@inclination_orbit),
      :math.cos(true_orbital_longitude - ascending_node_corrected_longitude)) + ascending_node_corrected_longitude

    latitude = :math.asin(:math.sin(true_orbital_longitude - ascending_node_corrected_longitude)*:math.sin(@inclination_orbit))

    longitude = Angle.normalize(radians: longitude)
    latitude = Angle.normalize_90_90(radians: latitude)

    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}}

  end
end
