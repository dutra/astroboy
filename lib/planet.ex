defmodule Planet do

  @period_orbit %{mercury: 0.240_85, earth: 0.999_996, jupiter: 11.857_911, saturn: 29.310_579} # (tropical years)
  @longitude_at_epoch %{mercury: 1.31889, earth: 1.737_593, jupiter: 5.897_767, saturn: 3.008_918} # (radians)
  @longitude_perihelion %{mercury: 1.354_6, earth: 1.801_28, jupiter: 0.255_9, saturn: 1.563} # (radians)
  @eccentricity_orbit %{mercury: 0.205_627, earth: 0.016_671, jupiter: 0.048_907, saturn: 0.053_853} #
  @semi_major_axis %{mercury: 0.387_098, earth: 0.999_985, jupiter: 5.202_78, saturn: 9.511_34} # AU
  @orbital_inclination %{mercury: 0.122_26, jupiter: 0.0227_5, saturn: 0.043_41} # radians
  @longitude_ascending_node %{mercury: 0.8456, jupiter: 1.7557, saturn: 1.985_3} # radians
  # @angular_diameter_au %{mercury: 6.74, jupiter: 196.74, saturn: 165.60} # arcsec
  # @visual_magnitude_au %{mercury: -0.42, jupiter: -9.4, saturn: -8.88} #
  @outer_planets [:jupiter, :saturn]


  def get_position(date: {{year, month, day}, {hour, minute, second}}, planet: planet) do

    %Epoch{day: day} = Epoch.init({{year, month, day}, {hour, minute, second}})

    # for Earth
    earth_mean_anomaly = 2*:math.pi/365.242_191 * day/@period_orbit[:earth] + @longitude_at_epoch[:earth] - @longitude_perihelion[:earth]

    earth_true_anomaly = earth_mean_anomaly + 2*@eccentricity_orbit[:earth]*:math.sin(earth_mean_anomaly)

    earth_heliocentric_longitude = earth_true_anomaly + @longitude_perihelion[:earth]
    # earth_heliocentric_latitude = 0.0
    earth_radius_vector_length = @semi_major_axis[:earth]*(1-:math.pow(@eccentricity_orbit[:earth], 2)) / (1 + @eccentricity_orbit[:earth]*:math.cos(earth_true_anomaly))

    # for Planet
    mean_anomaly = 2*:math.pi*day / (365.242_191*@period_orbit[planet]) + @longitude_at_epoch[planet] - @longitude_perihelion[planet]

    true_anomaly = mean_anomaly + 2*@eccentricity_orbit[planet]*:math.sin(mean_anomaly)

    heliocentric_longitude = true_anomaly + @longitude_perihelion[planet]
    heliocentric_latitude = :math.asin(:math.sin(heliocentric_longitude-@longitude_ascending_node[planet])*:math.sin(@orbital_inclination[planet]))
    radius_vector_length = @semi_major_axis[planet]*(1-:math.pow(@eccentricity_orbit[planet], 2)) / (1 + @eccentricity_orbit[planet]*:math.cos(true_anomaly))

    projected_heliocentric_longitude = :math.atan2(:math.sin(heliocentric_longitude-@longitude_ascending_node[planet])*:math.cos(@orbital_inclination[planet]), :math.cos(heliocentric_longitude-@longitude_ascending_node[planet])) + @longitude_ascending_node[planet]

    projected_radius_vector_length = radius_vector_length*:math.cos(heliocentric_latitude)

    longitude = if planet in @outer_planets do
      :math.atan2(earth_radius_vector_length*:math.sin(projected_heliocentric_longitude - earth_heliocentric_longitude),
        projected_radius_vector_length - earth_radius_vector_length*:math.cos(projected_heliocentric_longitude - earth_heliocentric_longitude)) +
      projected_heliocentric_longitude
    else
      :math.atan2(projected_radius_vector_length*:math.sin(earth_heliocentric_longitude - projected_heliocentric_longitude),
          earth_radius_vector_length - projected_radius_vector_length*:math.cos(earth_heliocentric_longitude - projected_heliocentric_longitude)) + earth_heliocentric_longitude + :math.pi
    end

    latitude = :math.atan2(projected_radius_vector_length*:math.tan(heliocentric_latitude)*:math.sin(longitude-projected_heliocentric_longitude),
    earth_radius_vector_length*:math.sin(projected_heliocentric_longitude-earth_heliocentric_longitude))

    longitude = Angle.normalize(radians: longitude)
    latitude = Angle.normalize(radians: latitude)

    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}}

  end

end
