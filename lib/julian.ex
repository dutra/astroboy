defmodule Julian do
  defstruct [:day]

  def is_gregorian(year, month, day) do
    (year > 1_582 and month > 10 and day > 15)
  end

  def init({{year, month, day}, {hour, minute, second}}) do
    julian_date(year, month, day, hour, minute, second)
  end

  def julian_date(year, month, day) do
    unless is_gregorian(year, month, day) do
      0
    end

    {m, y} = if month == 1 or month == 2 do
      {month + 12, year - 1}
    else
      {month, year}
    end

    a = trunc(y/100)
    b = 2 - a + trunc(a/4)

    c = if y < 0 do
      trunc((365.25*y)-0.75)
    else
      trunc(365.25*y)
    end

    d = trunc(30.6001*(m+1))
    jd = b+c+d+day+1_720_994.5
    jd
  end

  def julian_date(year, month, day, hour, minute, second) do
    jd = julian_date(year, month, day) + hour/24 + minute/1_440 + second/86_400
    %Julian{day: jd}
  end

end
