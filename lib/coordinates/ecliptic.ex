defmodule Coordinates.Ecliptic do
  defstruct [:latitude, :longitude]

  @typedoc """
  Type that represents Ecliptic Coordinates.
  """

  @type t :: %Coordinates.Ecliptic{latitude: Angle.t, longitude: Angle.t}

end
