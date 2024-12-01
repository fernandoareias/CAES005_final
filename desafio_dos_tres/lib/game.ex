defmodule DesafioDosTres.Game do
  alias DesafioDosTres.{Board, Player}

  def start_game do
    board = Board.new_board()
    players = [
      Player.new("Jogador 1", "X"),
      Player.new("Jogador 2", "O"),
      Player.new("Jogador 3", "#")
    ]
    loop(board, players, 0, nil)
  end

  defp loop(board, players, turn, last_erased_turn) do
    current_player = Enum.at(players, rem(turn, length(players)))
    IO.puts("\nVez de #{current_player.name} (#{current_player.symbol})")
    Board.print_board(board)

    {row, col} = get_move()

    can_play =
      Board.valid_move?(board, {row, col}) or
        (Player.can_erase?(current_player) and
           Board.opponent_symbol?(board, {row, col}, current_player.symbol) and
           (last_erased_turn == nil or last_erased_turn + 1 < turn))

    if can_play do
      erased = Board.opponent_symbol?(board, {row, col}, current_player.symbol)
      new_board = Board.update_board(board, {row, col}, current_player.symbol)
      new_players = update_player_can_erase(players, current_player, erased, turn)
      new_last_erased_turn = if erased, do: turn, else: last_erased_turn
      loop(new_board, new_players, turn + 1, new_last_erased_turn)
    else
      IO.puts("Movimento inválido! Tente novamente.")
      loop(board, players, turn, last_erased_turn)
    end
  end

  defp get_move do
    IO.gets("Digite a linha e coluna (ex: 1 2): ")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp update_player_can_erase(players, current_player, erased, turn) do
    updated_player =
      if erased do
        Player.update_can_erase(current_player, false)
        |> Player.update_last_erased_turn(turn)
      else
        Player.update_can_erase(current_player, true)
      end

    Enum.map(players, fn player ->
      if player.name == current_player.name do
        updated_player
      else
        player
      end
    end)
  end
end
