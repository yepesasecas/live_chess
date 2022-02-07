defmodule LiveChessWeb.TableLiveTest do
  use LiveChessWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "game" do
    test "disconnected and connected mount", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/table/1")
      assert html =~ "<strong>Table: </strong>1"
    end

    test "new", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/table/1")

      assert view
             |> element("button#new_game")
             |> render_click() =~ "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

      assert render_click(view, "click_square", %{"selected_square" => "e2"}) =~
               "e2"

      assert render_click(view, "click_square", %{"selected_square" => "e4"}) =~
               "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR"
    end

    test "as white player", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/table/3?player_name=andres")
      assert html =~ "andres"
      assert html =~ "square=\"a8\" class=\"white\"><img src=\"/images/black_r.png\""
    end

    test "as black player", %{conn: conn} do
      {:ok, _view, _html} = live(conn, "/table/4?player_name=white_player")
      {:ok, _view, html} = live(conn, "/table/4?player_name=black_player")
      assert html =~ "black_player"
      assert html =~ "square=\"h1\" class=\"white\"><img src=\"/images/white_r.png\"/>"
    end

    test "with both players", %{conn: conn} do
      {:ok, _view, _html} = live(conn, "/table/2?player_name=white_player")
      {:ok, _view, html} = live(conn, "/table/2?player_name=black_player")

      assert html =~ "white_player"
      assert html =~ "black_player"
    end
  end
end
