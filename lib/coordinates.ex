defmodule Coordinates do

  def to_ecliptic(%Coordinates.Ecliptic{latitude: latitude, longitude: longitude}) do
    %Coordinates.Ecliptic{latitude: latitude, longitude: longitude}
  end

  def to_ecliptic(%Coordinates.Equatorial{declination: alpha, ra: delta}) do
    # %Coordinates.Ecliptic{latitude: latitude, longitude: longitude}
  end

  @spec to_equatorial(Coordinates.Ecliptic.t, Julian.t) :: Coordinates.Equatorial.t
  def to_equatorial(%Coordinates.Ecliptic{latitude: %Angle{radians: beta},
                                          longitude: %Angle{radians: lambda}}, %Julian{day: day}) do
    epoch = Epoch.init(%Julian{day: day})
    obliquity = obliquity_ecliptic(epoch)
    alpha = :math.atan2(:math.sin(lambda)*:math.cos(obliquity) - :math.tan(beta)*:math.sin(obliquity), :math.cos(lambda))
    alpha = Angle.normalize(radians: alpha)
    delta = :math.asin(:math.sin(beta)*:math.cos(obliquity) + :math.cos(beta)*:math.sin(obliquity)*:math.sin(lambda))
    delta = Angle.normalize(radians: delta)

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
