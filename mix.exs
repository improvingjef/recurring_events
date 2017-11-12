defmodule Recur.Mixfile do
  use Mix.Project

  def project do
    [app: :recur,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: description(),
     docs: [
       main: Recur,
       source_url: "https://github.com/improvingjef/recur"
     ],
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Jef Newsom"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/improvingjef/recur"}
    ]
  end

  defp description do
    """
    Elixir library providing recurring calendar events support.
    """
  end
end
