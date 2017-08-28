defmodule Recur.Mixfile do
  use Mix.Project

  def project do
    [app: :recurring_events,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: description(),
     docs: [
       main: Recur,
       source_url: "https://github.com/pbogut/recurring_events"
     ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [maintainers: ["Pawel Bogut"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/pbogut/recurring_events"}]
  end

  defp description do
    """
    Elixir library providing recurring calendar events support.
    """
  end
end
