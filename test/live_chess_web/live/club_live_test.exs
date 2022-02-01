defmodule LiveChessWeb.ClubLiveTest do
  use LiveChessWeb.ConnCase
  import Phoenix.LiveViewTest

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "<h1>Welcome <strong></strong> to LiveChess!</h1>"
    assert html =~ "Search opponent"
  end
end
