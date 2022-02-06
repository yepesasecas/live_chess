defmodule LiveChess.Chess.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :uuid, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :uuid])
    |> validate_required([:name])
    |> validate_length(:name, max: 20)
  end

  def uuid do
    Ecto.UUID.generate()
  end
end
