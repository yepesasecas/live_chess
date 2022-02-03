defmodule LiveChessWeb.ClubLiveTest do
  use LiveChessWeb.ConnCase
  import Phoenix.LiveViewTest

  alias LiveChess.Chess

  describe "club" do
    test "disconnected and connected mount", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "<h1>Welcome <strong></strong> to LiveChess!</h1>"
      assert html =~ "Create table"
    end

    test "shows new table games", %{conn: conn} do
      # render ClubLive
      {:ok, club_view, _html} = live(conn, "/")

      # create new table
      params = %{"name" => "new_game_test"}

      player =
        Chess.new_player()
        |> Chess.change_player(%{name: "test_player"})
        |> Chess.apply_changes_to_player()

      LiveChess.LiveGamesServer.current_or_new(params, player)

      # assert club_view has new table game and player displayed
      html = render(club_view)
      assert html =~ "<h2>new_game_test</h2>"
      assert html =~ "test_player"
    end

    test "welcomes player by name", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{player: %{name: "jhon doe"}}) =~
               "<h1>Welcome <strong>jhon doe</strong> to LiveChess!</h1>"
    end
  end
end
