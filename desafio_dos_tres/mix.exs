defmodule DesafioDosTres.MixProject do
  use Mix.Project

  def project do
    [
      app: :desafio_dos_tres,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: DesafioDosTres.GameRunner],
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript do
    [main_module: DesafioDosTres.CLI]
  end

  defp aliases do
    [
      start: "run -e 'DesafioDosTres.GameRunner.main()'"
    ]
  end

end
