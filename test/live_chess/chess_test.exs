defmodule LiveChess.ChessTest do
  use LiveChess.DataCase

  test "create table" do
    assert %LiveChess.Chess.Table{
             name: "table_name_test",
             game: %Chess.Game{}
           } = LiveChess.Chess.new_table(name: "table_name_test")
  end

  describe "table" do
    alias LiveChess.Chess
    alias LiveChess.Chess.{Table, Player}

    test "create with white player" do
      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:white, %Player{name: "andres_white"})

      assert %Table{
               white_player: %Player{
                 name: "andres_white"
               }
             } = table
    end

    test "no players" do
      table = Chess.new_table(name: "table_name_test")
      assert :no_players = Chess.table_status(table)
    end

    test "waiting black player" do
      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:white, %Player{name: "andres_white"})

      assert :waiting_black_player = Chess.table_status(table)
    end

    test "waiting white player" do
      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:black, %Player{name: "felipe_black"})

      assert :waiting_white_player = Chess.table_status(table)
    end

    test "playing status" do
      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:white, %Player{name: "andres_white"})
        |> Chess.add_player(:black, %Player{name: "felipe_black"})

      assert :playing = Chess.table_status(table)
    end

    test "player is white player" do
      white_player =
        Chess.new_player()
        |> Chess.change_player(%{name: "andres_white"})
        |> Chess.apply_changes_to_player()

      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:white, white_player)

      assert :white_player = Chess.table_player_side(table, white_player)
    end

    test "player is black player" do
      black_player =
        Chess.new_player()
        |> Chess.change_player(%{name: "felipe_black"})
        |> Chess.apply_changes_to_player()

      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:black, black_player)

      assert :black_player = Chess.table_player_side(table, black_player)
    end

    test "player is a viewer" do
      white_player =
        Chess.new_player()
        |> Chess.change_player(%{name: "andres_white"})
        |> Chess.apply_changes_to_player()

      black_player =
        Chess.new_player()
        |> Chess.change_player(%{name: "felipe_black"})
        |> Chess.apply_changes_to_player()

      viewer_player =
        Chess.new_player()
        |> Chess.change_player(%{name: "viewer_player"})
        |> Chess.apply_changes_to_player()

      table =
        Chess.new_table(name: "table_name_test")
        |> Chess.add_player(:white, white_player)
        |> Chess.add_player(:black, black_player)

      assert :viewer = Chess.table_player_side(table, viewer_player)
    end
  end

  describe "player" do

    alias LiveChess.Chess
    alias LiveChess.Chess.Player

    test "new" do
      assert %Player{name: nil, uuid: _uuid} = Chess.new_player()
    end

    test "changeset" do
      player_changeset =
        Chess.new_player()
        |> Chess.change_player(%{name: "player"})

      assert %Ecto.Changeset{} = player_changeset
    end

    test "changes applied" do
      player =
        Chess.new_player()
        |> Chess.change_player(%{name: "player"})
        |> Chess.apply_changes_to_player()

      assert %Player{name: "player", uuid: _uuid} = player
    end
  end
end
