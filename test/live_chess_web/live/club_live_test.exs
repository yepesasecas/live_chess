defmodule LiveChessWeb.ClubLiveTest do
  use LiveChessWeb.ConnCase
  import Phoenix.LiveViewTest

  alias LiveChess.Chess

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "<h1>Welcome <strong></strong> to LiveChess!</h1>"
    assert html =~ "Create table"
  end

  test "new table shows in club view", %{conn: conn} do
    # render ClubLive
    {:ok, club_view, _html} = live(conn, "/")

    # create new table
    params = %{"name" => "new_game_test"}
    player = Chess.new_player()
      |> Chess.change_player(%{name: "test_player"})
      |> Chess.apply_changes_to_player

    LiveChess.LiveGamesServer.current_or_new(params, player)

    # assert club_view has new table game and player displayed
    html = render(club_view)
    assert html =~ "<h2>new_game_test</h2>"
    assert html =~ "test_player"
  end
end
