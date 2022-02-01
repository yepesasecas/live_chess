defmodule LiveChess.Chess.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 5, max: 20)
  end
end
