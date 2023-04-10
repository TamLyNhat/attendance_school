defmodule AttendanceServiceWeb.HighFeverView do
  use AttendanceServiceWeb, :live_view

  def render(_, assigns) do
    ~H"""
    <div>
    <h1>Show high fever events, distributed by school </h1>
      <div class="w-full max-w-xs" >
          <.live_component module={AttendanceServiceWeb.SchoolSelect}
                                  id="school_selected" />
      </div>
      <div>
          <.live_component module={AttendanceServiceWeb.ShowDataSchoolSelected}
                                  id="show_data"/>
      </div>
    </div>

    """
  end
end
