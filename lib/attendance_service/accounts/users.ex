defmodule AttendanceService.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset
  alias AttendanceService.StorageService.ApiUser

  schema "users" do
    field :user_name, :string
    field :school_name, :string
    field :temperature, :integer
    field :file_name, :string
    field :type, :string
    timestamps()
  end

  def changeset(users, params \\ %{}) do

    users
    |> cast(params, [:user_name, :school_name, :temperature])
    |> validate_required([:user_name, :school_name, :temperature])
    |> validate_length(:user_name, min: 1, max: 50)
    |> validate_length(:school_name, min: 1, max: 100)
    |> validate_number(:temperature, greater_than: 0, less_than: 100)
  end

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

    fun3 = fn(user_id) ->
      temp_random = Enum.random(15..50)
      ApiUser.insert(:storage_server, {user_id, "jack"
                     <> Integer.to_string(temp_random), "cccc", temp_random,
                     {<<137, 80, 78>>, "temp60119.png"}, :calendar.local_time(),
                     "check_in"})
    end

    fun4 = fn(user_id) ->
      temp_random = Enum.random(1..34)
      ApiUser.insert(:storage_server, {user_id, "math"
                     <> Integer.to_string(temp_random), "dddd", temp_random,
                     {<<137, 80, 78>>, "temp60119.png"}, :calendar.local_time(),
                     "check_in"})
    end

    for(n <- 1..50, do: fun.(n))
    for(n <- 51..60, do: fun2.(n))
    for(n <- 61..80, do: fun3.(n))
    for(n <- 81..82, do: fun4.(n))

  end

  @doc """
  Get list has 5 users data base on page number.

  If we have 15 users, get_list_on_page(1, data) will return user from 1st to
  5th.
  """
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

  def add_sample_data_for_date() do
      fun = fn(user_id, name) ->
          month_random = Enum.random(1..12)
          last_date = :calendar.last_day_of_the_month(2023, month_random)
          date_random = Enum.random(1..last_date)
          case :calendar.day_of_the_week(2023, month_random, date_random) do
            weekend when weekend == 6 or weekend == 7 ->
              :ok
            _ ->
              ApiUser.insert(:storage_server, {user_id, "join" <>
                            name, "aaaa", 20,
                            {<<137, 80, 78>>, "temp60119.png"},
                            {{2023, month_random, date_random}, {1, 1, 1}},
                            "check_in"})
          end
      end

      for(n <- 1..50, do: fun.(n, "1"))
      for(n <- 51..100, do: fun.(n, "2"))
      for(n <- 101..150, do: fun.(n, "3"))
      for(n <- 151..200, do: fun.(n, "4"))
  end

end
