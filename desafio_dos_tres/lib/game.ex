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

  defp loop(board, players, turn, last_erased_turn, last_victim_player, state) do
    current_player = Enum.at(players, rem(turn, length(players)))
    IO.puts("\nVez de #{current_player.name} (#{current_player.symbol})")
    Board.print_board(board)

    {row, col} = get_move()

    can_play =
      Board.valid_move?(board, {row, col}) or
      (Player.can_erase?(current_player) and
       Board.opponent_symbol?(board, {row, col}, current_player.symbol) and
       (state[:last_erased] == nil or state[:last_erased] != {row, col}) and
       last_victim_player != current_player.name)

    if can_play do
      erased = Board.opponent_symbol?(board, {row, col}, current_player.symbol)
      new_board = Board.update_board(board, {row, col}, current_player.symbol)

      last_victim_player_name =
        if erased do
          erased_symbol = Board.opponent_symbol?(board, {row, col}, current_player.symbol)
          case Enum.find(players, fn player -> player.symbol == erased_symbol end) do
            nil -> last_victim_player
            player -> player.name
          end
        else
          last_victim_player
        end

      new_players = update_player_can_erase(players, current_player, erased)
      new_last_erased_turn = if erased, do: turn, else: last_erased_turn

      if full_board?(new_board) do
        IO.puts("O tabuleiro está cheio! O jogo termina em empate.")
        Board.print_board(new_board)
        :ok
      else
        case check_winner(new_board, current_player.symbol) do
          {:winner, symbol} ->
            IO.puts("#{current_player.name} venceu com o símbolo #{symbol}!")
            Board.print_board(new_board)
            :ok

          :no_winner ->
            loop(
              new_board,
              new_players,
              turn + 1,
              new_last_erased_turn,
              last_victim_player_name,
              Map.put(state, :last_erased, if(erased, do: {row, col}, else: nil))
            )
        end
      end
    else
      IO.puts("Movimento inválido! Tente novamente.")
      loop(board, players, turn, last_erased_turn, last_victim_player, state)
    end
  end

  defp get_move do
    IO.gets("Digite a linha e coluna (ex: 1 2): ")
    |> String.trim()
    |> String.split()
    |> case do
         [row, col] ->
           case {Integer.parse(row), Integer.parse(col)} do
             {{row_int, _}, {col_int, _}} when row_int >= 0 and row_int < 4 and col_int >= 0 and col_int < 4 ->
               {row_int, col_int}

             _ ->
               IO.puts("Coordenadas inválidas! Tente novamente.")
               get_move()
           end

         _ ->
           IO.puts("Entrada inválida! Tente novamente.")
           get_move()
       end
  end

  defp update_player_can_erase(players, current_player, erased) do
    Enum.map(players, fn player ->
      if player == current_player do
        if erased do
          Player.update_can_erase(player, false)
        else
          Player.update_can_erase(player, true)
        end
      else
        player
      end
    end)
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
    Enum.any?(0..3, fn row ->
      Enum.any?(0..3, fn col ->
        check_diagonal_lr(board, row, col, symbol)
      end)
    end) or
    Enum.any?(0..3, fn row ->
      Enum.any?(0..3, fn col ->
        check_diagonal_rl(board, row, col, symbol)
      end)
    end)
  end

  defp check_diagonal_lr(board, row, col, symbol) do
    Enum.all?(0..3, fn i ->
      row + i < 4 and col + i < 4 and Enum.at(Enum.at(board, row + i), col + i) == symbol
    end)
  end

  defp check_diagonal_rl(board, row, col, symbol) do
    Enum.all?(0..3, fn i ->
      row + i < 4 and col - i >= 0 and Enum.at(Enum.at(board, row + i), col - i) == symbol
    end)
  end

  defp full_board?(board) do
    Enum.all?(board, fn row -> Enum.all?(row, fn cell -> cell != "." end) end)
  end
end
