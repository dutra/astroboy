defmodule Astroboy do
  @moduledoc """
  Documentation for Astroboy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Astroboy.hello
      :world

  """
  def hello do
    :world
  end

  def h do
    j = Julian.init({{2009, 6, 19}, {6, 0, 0}})
    Epoch.init(j)
  end

end
