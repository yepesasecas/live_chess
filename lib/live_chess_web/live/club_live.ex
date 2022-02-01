defmodule LiveChessWeb.ClubLive do
  use LiveChessWeb, :live_view

  alias LiveChess.Chess
  alias LiveChess.Chess.Player

  def mount(params, _session, socket) do
    player = Chess.new_player()
    {:ok, assign(socket, %{player: player, changeset: Chess.change_player(player, %{})})}
  end

  def handle_event("validate", %{"player" => params}, socket) do
    changeset =
      %Player{}
      |> Chess.change_player(params)
      |> Map.put(:action, :insert)

    player =
      if changeset.valid? do
        Chess.apply_changes_to_player(changeset)
      else
        socket.assigns[:player]
      end

    {:noreply, assign(socket, changeset: changeset, player: player)}
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    changeset = socket.assigns[:changeset]

    if changeset.valid? do
      {:noreply,
       socket
       |> put_flash(:info, "waiting opponent")
       |> redirect(to: Routes.live_path(LiveChessWeb.Endpoint, LiveChessWeb.TableLive, 1))}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    LiveChessWeb.ClubLiveView.render("index.html", assigns)
  end
end
