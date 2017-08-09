defmodule Coordinates.Equatorial do
  defstruct [:declination, :ra]

  @typedoc """
  Type that represents Equatorial Coordinates.
  """

  @type t :: %Coordinates.Equatorial{declination: Angle.t, ra: Angle.t}

end
