defmodule Kepler do
  @moduledoc """
  Documentation for Kepler.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Kepler.hello
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
