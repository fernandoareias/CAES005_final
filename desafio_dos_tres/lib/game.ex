defmodule DesafioDosTres.Game do
  alias DesafioDosTres.{Board, Player}

  def start_game do
    board = Board.new_board()
    players = [
      Player.new("Jogador 1", "X"),
      Player.new("Jogador 2", "O"),
      Player.new("Jogador 3", "#")
    ]
    loop(board, players, 0, nil, nil, %{last_erased: nil})
  end

  defp loop(board, players, turn, last_erased_turn, last_erased_player, state) do
    current_player = Enum.at(players, rem(turn, length(players)))
    IO.puts("\nVez de #{current_player.name} (#{current_player.symbol})")
    Board.print_board(board)

    {row, col} = get_move()


    can_play =
      Board.valid_move?(board, {row, col}) or
        (Player.can_erase?(current_player) and
           Board.opponent_symbol?(board, {row, col}, current_player.symbol) and
           (state[:last_erased] == nil or state[:last_erased] != {row, col} or (turn - last_erased_turn) >= length(players) and last_erased_player != current_player.name))

    if can_play do
      erased = Board.opponent_symbol?(board, {row, col}, current_player.symbol)
      new_board = Board.update_board(board, {row, col}, current_player.symbol)
      new_players = update_player_can_erase(players, current_player, erased)
      new_last_erased_turn = if erased, do: turn, else: last_erased_turn
      new_last_erased_player = if erased, do: current_player.name, else: last_erased_player

      case check_winner(new_board, current_player.symbol) do
        {:winner, symbol} ->
          IO.puts("#{current_player.name} venceu com o símbolo #{symbol}!")
          Board.print_board(new_board)
          :ok
        :no_winner ->
          loop(new_board, new_players, turn + 1, new_last_erased_turn, new_last_erased_player, Map.put(state, :last_erased, if erased do {row, col} else nil end))
      end
    else
      IO.puts("Movimento inválido! Tente novamente.")
      loop(board, players, turn, last_erased_turn, last_erased_player, %{})
    end
  end

  defp get_move do
    IO.gets("Digite a linha e coluna (ex: 1 2): ")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp update_player_can_erase(players, current_player, erased) do
    updated_player =
      Enum.map(players, fn player ->
        if player == current_player and erased do
          Player.update_can_erase(player, false)
        else
          player
        end
      end)
    updated_player
  end

  defp check_winner(board, symbol) do
    if check_horizontals(board, symbol) or
       check_verticals(board, symbol) or
       check_diagonals(board, symbol) do
      {:winner, symbol}
    else
      :no_winner
    end
  end

  defp check_horizontals(board, symbol) do
    Enum.any?(board, fn row ->
      Enum.chunk_every(row, 4, 1, :discard)
      |> Enum.any?(fn chunk -> Enum.all?(chunk, fn cell -> cell == symbol end) end)
    end)
  end

  defp check_verticals(board, symbol) do
    0..3
    |> Enum.any?(fn col ->
      Enum.chunk_every(Enum.map(board, fn row -> Enum.at(row, col) end), 4, 1, :discard)
      |> Enum.any?(fn chunk -> Enum.all?(chunk, fn cell -> cell == symbol end) end)
    end)
  end

  defp check_diagonals(board, symbol) do
    # Diagonal principal (de cima para baixo, da esquerda para a direita)
    Enum.any?(0..3, fn row ->
      Enum.any?(0..3, fn col ->
        check_diagonal(board, row, col, symbol)
      end)
    end)
  end

  defp check_diagonal(board, row, col, symbol) do
    for i <- 0..3 do
      case Enum.at(board, row + i) do
        nil -> false
        row -> Enum.at(row, col + i) == symbol
      end
    end
    |> Enum.all?()
  end
end
