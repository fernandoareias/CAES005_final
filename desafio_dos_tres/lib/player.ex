defmodule DesafioDosTres.Player do
  defstruct [:name, :symbol, :can_erase, :last_erased_turn]

  def new(name, symbol) do
    %DesafioDosTres.Player{name: name, symbol: symbol, can_erase: true, last_erased_turn: nil}
  end

  def update_can_erase(player, value) do
    %DesafioDosTres.Player{player | can_erase: value}
  end

  def can_erase?(%DesafioDosTres.Player{can_erase: can_erase}) do
    can_erase
  end
end
