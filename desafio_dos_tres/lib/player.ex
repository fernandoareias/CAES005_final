defmodule DesafioDosTres.Player do
  defstruct [:name, :symbol, :can_erase]

  def new(name, symbol) do
    %DesafioDosTres.Player{name: name, symbol: symbol, can_erase: true}
  end

  def update_can_erase(player, value) do
    %DesafioDosTres.Player{player | can_erase: value}
  end

  def can_erase?(%DesafioDosTres.Player{can_erase: can_erase}) do
    can_erase
  end
end
