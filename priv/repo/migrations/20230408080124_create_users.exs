defmodule AttendanceService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_name, :string
      add :school_name, :string
      add :temperature, :integer
      add :file_name, :string
      add :type, :string
      timestamps()
    end
  end
end
