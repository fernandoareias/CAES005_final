defmodule DesafioDosTres.Player do
  defstruct [:name, :symbol, :can_erase]

  def new(name, symbol) do
    %DesafioDosTres.Player{name: name, symbol: symbol, can_erase: true}
  end
end
