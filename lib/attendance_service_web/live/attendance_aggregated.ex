defmodule AttendanceServiceWeb.AttendanceAggregatedView do
  use AttendanceServiceWeb, :live_view

  def render(_, assigns) do
    ~H"""
    <div>
    <h1>Show school attendance aggregated by day / week / month (present, absent)</h1>
      <div class="w-full max-w-xs" >
          <.live_component module={AttendanceServiceWeb.TypeSelect}
                                  id="type_selected" />
      </div>
      <div>
          <.live_component module={AttendanceServiceWeb.DayWeekOrMonth}
                                  id="day_week_or_month"/>
      </div>
      <div>
          <.live_component module={AttendanceServiceWeb.ShowDataAttendance}
                                  id="show_data"/>
      </div>
    </div>

    """
  end
end
