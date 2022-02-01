defmodule LiveChess.ChessTest do
  use LiveChess.DataCase

  test "create table with no Players" do
    assert %LiveChess.Chess.Table{
             name: "table_name_test",
             game: %Chess.Game{}
           } = LiveChess.Chess.new_table(%{"table_name" => "table_name_test"})
  end

  test "create table with white palyer" do
    table =
      LiveChess.Chess.new_table(%{
        "table_name" => "table_name_test",
        "player_name" => "andres_white"
      })

    assert %LiveChess.Chess.Table{
             white_player: %LiveChess.Chess.Player{
               name: "andres_white"
             }
           } = table
  end
end
