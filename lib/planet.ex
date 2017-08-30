defmodule Planet do

  @period_orbit %{mercury: 0.240_85, venus: 0.615_207, earth: 0.999_996, mars: 1.880_765, jupiter: 11.857_911, saturn: 29.310_579, uranus: 84.039492, neptune: 165.84539} # (tropical years)
  @longitude_at_epoch %{mercury: 1.31889, venus: 4.752539, earth: 1.737_593, mars: 1.904_092, jupiter: 5.897_767, saturn: 3.008_918, uranus: 4.7309444, neptune: 5.7053963} # (radians)
  @longitude_perihelion %{mercury: 1.354_6, venus: 2.296, earth: 1.801_28, mars: 5.868_1, jupiter: 0.255_9, saturn: 1.563, uranus: 3.0174096, neptune: 0.40265} # (radians)
  @eccentricity_orbit %{mercury: 0.205_627, venus: 0.006_812, earth: 0.016_671, mars: 0.093_348, jupiter: 0.048_907, saturn: 0.053_853, uranus: 0.046321, neptune: 0.010483} #
  @semi_major_axis %{mercury: 0.387_098, venus: 0.723_32, earth: 0.999_985, mars: 1.523_689, jupiter: 5.202_78, saturn: 9.511_34, uranus: 19.21814, neptune: 30.1985} # AU
  @orbital_inclination %{mercury: 0.122_26, venus: 0.05925, mars: 0.03228, jupiter: 0.0227_5, saturn: 0.043_41, uranus: 0.0134924, neptune: 0.03085} # radians
  @longitude_ascending_node %{mercury: 0.8456, venus: 1.3399, mars: 0.8662, jupiter: 1.7557, saturn: 1.985_3, uranus: 1.2902689, neptune: 2.3017} # radians
  # @angular_diameter_au %{mercury: 6.74, venus: 16.92, mars: 9.36, jupiter: 196.74, saturn: 165.60, uranus: 65.80, neptune: 62.20} # arcsec
  # @visual_magnitude_au %{mercury: -0.42, venus: -4.40, mars: -1.52, jupiter: -9.4, saturn: -8.88, uranus: -7.19, neptune: -6.87} #
  @outer_planets [:mars, :jupiter, :saturn, :uranus, :neptune]


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

    latitude = :math.atan((projected_radius_vector_length*:math.tan(heliocentric_latitude)*:math.sin(longitude-projected_heliocentric_longitude))/(earth_radius_vector_length*:math.sin(projected_heliocentric_longitude-earth_heliocentric_longitude)))


    longitude = Angle.normalize(radians: longitude)
    latitude = Angle.normalize_90_90(radians: latitude)

    %Coordinates.Ecliptic{latitude: %Angle{radians: latitude},
                          longitude: %Angle{radians: longitude}}

  end

end
