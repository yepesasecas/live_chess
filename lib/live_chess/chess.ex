defmodule LiveChess.Chess do
  alias LiveChess.Chess.{Board, Table, Move}

  # Chess Game

  def new_table(name: name) do
    %Table{
      name: name,
      game: Chess.new_game()
    }
  end

  def game_play(%Table{game: game} = table, %Move{} = move) do
    case Chess.play(game, Move.to_string(move)) do
      {:ok, updated_game} ->
        {:ok, Map.put(table, :game, updated_game)}
      {:error, msg} ->
        {:error, msg}
    end

  end

  # Move

  def new_move(from: from_square, to: to_square) do
    %Move{from: from_square, to: to_square}
  end

  # Chessboard

  def board_square_pgn(i) do
    Board.square_pgn(i)
  end

  def board_square_color(i) do
    Board.square_color(i)
  end
end