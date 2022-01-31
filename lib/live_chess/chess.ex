defmodule LiveChess.Chess do
  alias LiveChess.Chess.{Board, Move}

  # Chess Game

  def new_game do
    Chess.new_game()
  end

  def game_play(game, %Move{} = move) do
    Chess.play(game, Move.to_string(move))
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