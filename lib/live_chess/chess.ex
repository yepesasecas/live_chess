defmodule LiveChess.Chess do
  alias LiveChess.Chess.{Board, Table, Move, Player}
  alias Ecto.Changeset

  # Chess Game
  def chess_game_struct, do: %Chess.Game{}

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

  def table_new_game(%Table{} = table) do
    Map.put(table, :game, Chess.new_game())
  end

  def table_status(%Table{} = table) do
    Table.status(table)
  end

  def add_player(%Table{white_player: nil} = table, :white, %Player{} = player) do
    %{table | white_player: player}
  end

  def add_player(%Table{black_player: nil} = table, :black, %Player{} = player) do
    %{table | black_player: player}
  end

  def add_player(%Table{} = table, _side, _player) do
    table
  end

  def table_player_side(%Table{white_player: %Player{uuid: uuid}}, %Player{uuid: uuid}) do
    :white_player
  end

  def table_player_side(%Table{black_player: %Player{uuid: uuid}}, %Player{uuid: uuid}) do
    :black_player
  end

  def table_player_side(_table, _player), do: :viewer

  # Move

  def new_move(from: from_square, to: to_square) do
    %Move{from: from_square, to: to_square}
  end

  # Chessboard

  def board_square_pgn(i) do
    Board.square_pgn(i)
  end

  def board_square_pgn(:black, i) do
    Board.square_pgn(:black, i)
  end

  def board_square_color(i) do
    Board.square_color(i)
  end

  # Player

  def new_player do
    %Player{uuid: Ecto.UUID.generate()}
  end

  def change_player(player, params) do
    player
    |> Player.changeset(params)
  end

  def apply_changes_to_player(changeset) do
    Changeset.apply_changes(changeset)
  end
end
