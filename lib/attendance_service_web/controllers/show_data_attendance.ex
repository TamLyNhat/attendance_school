defmodule AttendanceServiceWeb.ShowDataAttendance do
  use Phoenix.LiveComponent
  alias AttendanceService.StorageService.ApiUser

  @public_holiday [{2023, 1, 1}, {2023, 1, 2}, {2023, 1, 21}, {2023, 1, 22},
                   {2023, 1, 23}, {2023, 1, 24}, {2023, 1, 25}, {2023, 1, 26},
                   {2023, 1, 27}, {2023, 4, 29}, {2023, 4, 30}, {2023, 5, 1},
                   {2023, 5, 2}, {2023, 9, 2}, {2023, 4, 9}]


  @impl true
  def render(assigns) do
    ~H"""
    <div phx-target={@myself}>
              <div>
                  <label>Date: <%= @options.date %></label>
              </div>

              <div>
                  <table>
                      <tr>
                          <th></th>
                          <th>Present or absent</th>
                      </tr>
                      <%= for {users, _, status} <- @options.filter_data do %>
                          <tr>
                              <th>
                                  <%= users %>
                              </th>
                              <th>
                                  <%= status %>
                              </th>
                          </tr>
                          <% end %>
                  </table>
              </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do

    {:ok, assign(socket, options: %{date: "not selected yet", filter_data: []})}
  end

  @doc """
  Receive data from AttendanceServiceWeb.HighFeverController and load data to
  live component
  """
  @impl true
  def update(%{action: {:selected_type, date}}, socket) do
    list_user = ApiUser.get_user_base_on_sc(:storage_server, {"aaaa"})

    new_list_status =
      list_user
      |> add_status(date)
      |> do_add_status()
      |> do_check_weekend()

      {year, month, day} = date
      new_date_format = Integer.to_string(year) <> "-" <>
      Integer.to_string(month) <> "-" <> Integer.to_string(day)


    {:ok, assign(socket, options: %{date: new_date_format, filter_data: new_list_status})}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @doc """
  Add status
  """
  def add_status([], _) do
    []
  end

  def add_status([{_, user_name, _, _, _, {date, _},_} | t], date) do
    [{user_name, date, "present"}]  ++ add_status(t, date)
  end


  def add_status([{_, user_name, _, _, _, {user_date, _}, _} | t], date) do

    [{user_name, user_date, "absent"}] ++ add_status(t, date)
  end

  def do_add_status([]) do
    []
  end

  def do_add_status([{_user_name, _user_date, "absent"} | t]) do
    do_add_status(t)
  end

  def do_add_status([{user_name, user_date, _status} = user_info | t]) do
    is_public_holiday = Enum.any?(@public_holiday, &(&1 == user_date))
    case is_public_holiday do
      true ->
        [{user_name, user_date, "absent"}] ++ do_add_status(t)
      false ->
        [user_info] ++ do_add_status(t)
    end
  end

  @doc """
  Check whether date is weekend or not, if date is weekend, marks user as
  absent, otherwise keep status as present
  """
  def do_check_weekend([]) do
    []
  end

  def do_check_weekend([{_user_name, _user_date, "absent"} | t]) do
    do_add_status(t)
  end

  def do_check_weekend([{user_name, user_date, _status} | t]) do
    is_weekend = :calendar.day_of_the_week(user_date)
    case ((is_weekend == 6) or (is_weekend == 7)) do
      true ->
        [{user_name, user_date, "absent"}] ++ do_check_weekend(t)
      false ->
          do_add_status(t)
    end
  end

end
