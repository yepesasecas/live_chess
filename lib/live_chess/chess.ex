defmodule LiveChess.Chess do
  alias LiveChess.Chess.{Board, Table, Move, Player, Fen}
  alias Ecto.Changeset

  # Chess Game

  def new_table(name: name) do
    game = Chess.new_game()
    fen = Fen.from_string(game.current_fen)

    %Table{
      name: name,
      game: game,
      fen: fen
    }
  end

  def game_play(%Table{game: game} = table, %Move{} = move) do
    case Chess.play(game, Move.to_string(move)) do
      {:ok, updated_game} ->
        table =
          table
          |> Map.put(:game, updated_game)
          |> Map.put(:fen, Fen.from_string(updated_game.current_fen))
          |> Map.put(:last_move, move)

        {:ok, table}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def table_new_game(%Table{} = table) do
    new_game = Chess.new_game()

    table
    |> Map.put(:game, new_game)
    |> Map.put(:fen, Fen.from_string(new_game.current_fen))
    |> Map.put(:last_move, nil)
  end

  def table_status(%Table{} = table) do
    Table.status(table)
  end

  def add_player(%Table{} = table, %Player{} = player) do
    case Table.status(table) do
      :playing ->
        table

      :waiting_black_player ->
        add_player(table, :black, player)

      :waiting_white_player ->
        add_player(table, :white, player)

      :no_players ->
        add_player(table, :random, player)
    end
  end

  def add_player(%Table{} = table, :random, %Player{} = player) do
    case Enum.random(0..1) do
      0 ->
        add_player(table, :white, player)

      1 ->
        add_player(table, :black, player)
    end
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

  def table_player_side(_table, _player), do: :none

  def who_move_next?(%Table{fen: %Fen{active_color: active_color}}) do
    active_color
  end

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
    %Player{uuid: Player.uuid()}
  end

  def change_player(player, params) do
    player
    |> Player.changeset(params)
  end

  def apply_changes_to_player(changeset) do
    Changeset.apply_changes(changeset)
  end
end
