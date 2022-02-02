defmodule LiveChessWeb.TableLiveTest do
  use LiveChessWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "game" do
    test "disconnected and connected mount", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/table/1")
      assert html =~ "<h1>Table: 1</h1>"
    end

    test "new", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/table/1")

      assert view
             |> element("button#new_game")
             |> render_click() =~ "game fen: rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

      assert render_click(view, "click_square", %{"selected_square" => "e2"}) =~
               "<div>from: e2</div>"

      assert render_click(view, "click_square", %{"selected_square" => "e4"}) =~
               "game fen: rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR"
    end

    test "as white player", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/table/3?player_name=andres")
      assert html =~ "white player: andres"
    end

    test "with both players", %{conn: conn} do
      {:ok, _view, _html} = live(conn, "/table/2?player_name=white")
      {:ok, _view, html} = live(conn, "/table/2?player_name=black")

      assert html =~ "white player: white"
      assert html =~ "black player: black"
    end
  end
end
