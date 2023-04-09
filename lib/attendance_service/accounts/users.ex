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

  alias AttendanceService.StorageService.ApiUser
  def add_sample_data() do
    fun = fn(user_id) ->
      temp_random = Enum.random(30..70)
      ApiUser.insert(:storage_server, {user_id, "join" <>
                     Integer.to_string(temp_random), "aaaa", temp_random,
                     {<<137, 80, 78>>, "temp60119.png"}, :calendar.local_time(),
                     "check_in"})
    end

    fun2 = fn(user_id) ->
      temp_random = Enum.random(20..80)
      ApiUser.insert(:storage_server, {user_id, "johan"
                     <> Integer.to_string(temp_random), "bbbb", temp_random,
                     {<<137, 80, 78>>, "temp60119.png"}, :calendar.local_time(),
                     "check_in"})
    end

    for(n <- 1..50, do: fun.(n))
    for(n <- 51..60, do: fun2.(n))
  end

  def get_list_on_page(page_num, data) do
    start_num = (page_num - 1) * 5
    end_num = start_num + 5
    get_list(start_num , end_num, data)
  end

  def get_list(start_num, start_num, _data) do
    []
  end

  def get_list(start_num, end_num, data) do
    [Enum.at(data, start_num)] ++ get_list(start_num + 1, end_num, data)
  end

end
