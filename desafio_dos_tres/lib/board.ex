defmodule DesafioDosTres.Board do
  @size 4

  def new_board do
    for _ <- 1..@size, do: (for _ <- 1..@size, do: ".")
  end

  def print_board(board) do
    Enum.each(board, fn row ->
      IO.puts(Enum.join(row, "  "))
    end)
  end

  def update_board(board, {row, col}, symbol) do
    List.update_at(board, row, fn current_row ->
      List.update_at(current_row, col, fn _ -> symbol end)
    end)
  end

  def valid_move?(board, {row, col}) do
    board |> Enum.at(row) |> Enum.at(col) == "."
  end

  def opponent_symbol?(board, {row, col}, player_symbol) do
    current_symbol = board |> Enum.at(row) |> Enum.at(col)
    current_symbol != "." and current_symbol != player_symbol
  end
end
