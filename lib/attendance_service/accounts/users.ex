defmodule AttendanceService.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :user_name, :string
    field :school_name, :string
    field :temperature, :integer
    field :file_name, :string
    field :type, :string
    timestamps()
  end

  require Logger

  def changeset(users, params \\ %{}) do

    users
    |> cast(params, [:user_name, :school_name, :temperature])
    |> validate_required([:user_name, :school_name, :temperature])
    |> validate_length(:user_name, min: 1, max: 50)
    |> validate_length(:school_name, min: 1, max: 100)
    |> validate_number(:temperature, greater_than: 0, less_than: 100)
  end
end
