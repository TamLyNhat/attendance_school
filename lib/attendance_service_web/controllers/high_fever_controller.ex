defmodule AttendanceServiceWeb.HighFeverController do
  alias AttendanceService.Accounts.Users
  alias AttendanceService.StorageService.ApiUser

  use Phoenix.LiveView

  @impl true
  def render(assigns) do
    Phoenix.View.render(AttendanceServiceWeb.HighFeverView, "high_fever.html",
                        assigns)
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, assign(socket, [])}
  end

  @doc """
  Receive message from AttendanceServiceWeb.SchoolSelect
  And get all user has temperature higher than 38 degree, then push data to
  AttendanceServiceWeb.ShowDataSchoolSelected
  """
  @impl true
  def handle_info({:search, %{"search" => %{"school_name" => school_name}}},
                  socket) do

    data = ApiUser.get_higher_fever(:storage_server, {:get_higher_fever,
                                    school_name})
    filter_data = Users.get_list_on_page(1, data)
    total_data = Enum.count(data)
    max_page =
      total_data/5
      |> Decimal.from_float
      |> Decimal.round(0, :up)
      |> Decimal.to_integer()
    msg = {filter_data, total_data, data, max_page}

    send_update(AttendanceServiceWeb.ShowDataSchoolSelected, id: "show_data",
                action: {:load_data, msg})
    {:noreply, socket}
  end

  @doc """
  If current page = 1, get previous page will not affect
  """
  @impl true
  def handle_event("previous", %{"page" => "0", "value" => ""}, socket) do
    {:noreply, socket}
  end


  @doc """
  Get previous 5 users
  """
  @impl true
  def handle_event("previous", %{"page" => current_page}, socket) do
    send_update(AttendanceServiceWeb.ShowDataSchoolSelected, id: "show_data",
    action: {:load_previous, current_page})

    {:noreply, socket}
  end

  @doc """
  Get next 5 users
  """
  @impl true
  def handle_event("next", %{"page" => current_page}, socket) do
    send_update(AttendanceServiceWeb.ShowDataSchoolSelected, id: "show_data",
    action: {:load_next, current_page})

    {:noreply, socket}
  end
end
