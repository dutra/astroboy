defmodule Epoch do
  defstruct [:day]

  # Epoch is defined as January 0.0 2010
  def init(%Julian{day: day}) do
    %Epoch{day: day-2_455_196.5}
  end

  def init({{year, month, day}, {hour, minute, second}}) do
    jd = Julian.init({{year, month, day}, {hour, minute, second}})
    epoch = init(jd)
    epoch
  end

end
