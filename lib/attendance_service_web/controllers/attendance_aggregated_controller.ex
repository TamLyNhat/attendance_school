defmodule AttendanceServiceWeb.AttendanceAggregatedController do
  alias AttendanceService.Accounts.Users

  use Phoenix.LiveView

  @impl true
  def render(assigns) do
    Phoenix.View.render(AttendanceServiceWeb.AttendanceAggregatedView,
                        "attendance_aggregated.html", assigns)
  end

  @impl true
  def mount(_params, _, socket) do
    Users.add_sample_data_for_date()
    {:ok, assign(socket, [])}
  end

  @doc """
  Receive message from AttendanceServiceWeb.SchoolSelect
  And get all user has temperature higher than 38 degree, then push data to
  AttendanceServiceWeb.ShowDataSchoolSelected
  """
  require Logger

  @impl true
  def handle_info({:search, %{"search" => %{"change_type" => new_type}}},
                  socket) do
    send_update(AttendanceServiceWeb.DayWeekOrMonth, id: "day_week_or_month",
                action: {:change_type, new_type})
    {:noreply, socket}
  end

  def handle_info({:selected_type, date},
                  socket) do

    send_update(AttendanceServiceWeb.ShowDataAttendance, id: "show_data",
                action: {:selected_type, date})
    {:noreply, socket}
  end

end
