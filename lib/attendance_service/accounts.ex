defmodule AttendanceService.Accounts do
  @moduledoc """
  The Accounts context.
  """
  alias AttendanceService.Accounts.Users

  def change_user(%Users{} = user) do
    Users.changeset(user, %{})
  end

  @doc """
  Check changeset whether the changes are valid or not
  """
  def check_changeset(attrs \\ %{}) do
    case Ecto.Changeset.apply_action(attrs, :insert) do
      {:error, _} = error ->
        {:error, error}
      {:ok, _data} ->
        :ok
    end
  end

  @doc """
  Save binary data of image selected and file name
  """
  def get_image_info(_file_name, path) do
    random_number = Integer.to_string(Enum.random(0..1000000000000000))
    new_file_name = "temp" <> random_number <> ".png"
    new_path =  Path.join(["priv/static/images/", new_file_name])
    :ok = File.cp(path, new_path)
    {:ok, binary} = File.read(new_path)
    File.rm_rf!(new_path)
    {binary, new_file_name}
  end
end
