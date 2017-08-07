defmodule Kepler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kepler,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    """
    Kepler is a library in progress that aims at implementing methods to calculate the position of Planets, Sun and Moon.
    It also offers useful functions to convert among coordinate systems and other astronomy-related calculations.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Isaque Dutra"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/dutra/kepler"}
    ]
  end

end
