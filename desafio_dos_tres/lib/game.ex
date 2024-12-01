defmodule DesafioDosTres.Game do
  alias DesafioDosTres.{Board, Player}

  def start_game do
    board = Board.new_board()
    players = [
      Player.new("Jogador 1", "X"),
      Player.new("Jogador 2", "O"),
      Player.new("Jogador 3", "#")
    ]
    loop(board, players, 0)
  end

  defp loop(board, players, turn) do
    current_player = Enum.at(players, rem(turn, length(players)))
    IO.puts("\nVez de #{current_player.name} (#{current_player.symbol})")
    Board.print_board(board)

    {row, col} = get_move()

    if Board.valid_move?(board, {row, col}) or (current_player.can_erase and Board.opponent_symbol?(board, {row, col}, current_player.symbol)) do
      new_board = Board.update_board(board, {row, col}, current_player.symbol)
      new_players = update_player_can_erase(players, current_player, Board.opponent_symbol?(board, {row, col}, current_player.symbol))
      loop(new_board, new_players, turn + 1)
    else
      IO.puts("Movimento inválido! Tente novamente.")
      loop(board, players, turn)
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
      if erased do
        Player.update_can_erase(current_player, false)
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
