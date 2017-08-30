defmodule Coordinates do

  def to_ecliptic(%Coordinates.Ecliptic{latitude: latitude, longitude: longitude}) do
    %Coordinates.Ecliptic{latitude: latitude, longitude: longitude}
  end

  @spec to_ecliptic(Coordinates.Equatorial.t, Julian.t) :: Coordinates.Ecliptic.t
  def to_ecliptic(%Coordinates.Equatorial{declination: %Angle{radians: delta},
                                          ra: %Angle{radians: alpha}}, %Julian{day: day}) do
    epoch = Epoch.init(%Julian{day: day})
    obliquity = obliquity_ecliptic(epoch)

    lambda = :math.atan2(:math.sin(alpha)*:math.cos(obliquity) + :math.tan(delta)*:math.sin(obliquity),
      :math.cos(alpha))

    beta = :math.asin(:math.sin(delta)*:math.cos(obliquity) - :math.cos(delta)*:math.sin(obliquity)*:math.sin(alpha))

    lambda = Angle.normalize(radians: lambda)
    # beta = Angle.normalize(radians: beta)

    %Coordinates.Ecliptic{latitude: %Angle{radians: beta},
      longitude: %Angle{radians: lambda}}
  end

  @spec to_equatorial(Coordinates.Ecliptic.t, Julian.t) :: Coordinates.Equatorial.t
  def to_equatorial(%Coordinates.Ecliptic{latitude: %Angle{radians: beta},
                                          longitude: %Angle{radians: lambda}}, %Julian{day: day}) do
    epoch = Epoch.init(%Julian{day: day})
    obliquity = obliquity_ecliptic(epoch)
    alpha = :math.atan2(:math.sin(lambda)*:math.cos(obliquity) - :math.tan(beta)*:math.sin(obliquity), :math.cos(lambda))
    alpha = Angle.normalize(radians: alpha)
    delta = :math.asin(:math.sin(beta)*:math.cos(obliquity) + :math.cos(beta)*:math.sin(obliquity)*:math.sin(lambda))
    delta = Angle.normalize_90_90(radians: delta)

    %Coordinates.Equatorial{declination: %Angle{radians: delta},
                            ra: %Angle{radians: alpha}}
  end

  defp obliquity_ecliptic(%Epoch{day: day}) do
    # mjd = day -  2_451_545.0 # JD for epoch 2000 January 1.4
    mjd = day
    t = mjd/36_525.0
    de = 46.815*t + 0.0006*:math.pow(t, 2) - 0.00181*:math.pow(t, 3) # in arcsec
    de = 23.439_292 - de / 3600 # in degrees
    de = Angle.to_radians(degrees: de) # in radians
    de
  end

end
