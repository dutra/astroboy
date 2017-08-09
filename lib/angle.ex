defmodule Angle do

  defstruct [:radians]

  @typedoc """
  Type that represents angles in radians.
  """

  @type t :: %Angle{radians: float}

  def to_radians(%Angle{radians: radians}) do
    radians
  end

  def to_radians(degrees: degrees) do
    degrees / 180 * :math.pi
  end

  def to_degrees(%Angle{radians: radians}) do
    radians / :math.pi * 180
  end

  def normalize(%Angle{radians: radians}) do
    radians = if radians < 0 do
      n = abs(trunc(radians/(2*:math.pi))) + 1
      :math.fmod(radians + n*2*:math.pi, 2*:math.pi)
    else
      radians
    end

    %Angle{radians: radians}
  end

  def normalize(radians: radians) do
    radians = if radians < 0 do
      n = abs(trunc(radians/(2*:math.pi))) + 1
      :math.fmod(radians + n*2*:math.pi, 2*:math.pi)
    else
      radians
    end

    radians
  end
end
