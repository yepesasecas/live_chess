defmodule LiveChess.Chess do
  alias LiveChess.Chess.{Board, Table, Move, Player}
  alias Ecto.Changeset

  # Chess Game

  def new_table(params) do
    table = %Table{
      name: params["table_name"],
      game: Chess.new_game()
    }

    player_name = Map.get(params, "player_name", nil)

    if player_name == nil do
      table
    else
      Map.put(table, :white_player, %Player{name: player_name})
    end
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

  # Player

  def new_player do
    %Player{}
  end

  def change_player(player, params) do
    player
    |> Player.changeset(params)
  end

  def apply_changes_to_player(changeset) do
    Changeset.apply_changes(changeset)
  end
end


