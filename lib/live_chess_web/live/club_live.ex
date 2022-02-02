defmodule LiveChessWeb.ClubLive do
  use LiveChessWeb, :live_view

  alias LiveChess.Chess
  alias LiveChess.LiveGamesServer
  alias LiveChess.Chess.Player

  def mount(_params, _session, socket) do
    player = Chess.new_player()
    changeset = Chess.change_player(player, %{})
    club_tables = LiveGamesServer.get_all()
    LiveChessWeb.Endpoint.subscribe(LiveGamesServer.all_tables_topic())
    {:ok, assign(socket, %{player: player, changeset: changeset, club_tables: club_tables})}
  end

  def handle_event("validate", %{"player" => player_params} = params, socket) do
    changeset =
      %Player{}
      |> Chess.change_player(player_params)
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
    player = socket.assigns[:player]

    if changeset.valid? do
      {:noreply,
       socket
       |> put_flash(:info, "waiting opponent")
       |> redirect(
         to:
           Routes.live_path(
             LiveChessWeb.Endpoint,
             LiveChessWeb.TableLive,
             LiveChess.Dictionary.two_random_words(),
             player_name: player.name
           )
       )}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:all_tables, tables}, socket) do
    {:noreply, assign(socket, club_tables: tables)}
  end

  def render(assigns) do
    LiveChessWeb.ClubLiveView.render("index.html", assigns)
  end
end
