defmodule DesafioDosTres.GameRunner do
  alias DesafioDosTres.Game

  def main(_args) do
    IO.puts("Bem-vindo ao Desafio dos Três!")
    Game.start_game()
  end
end
