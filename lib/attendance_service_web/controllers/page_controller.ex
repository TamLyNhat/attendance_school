defmodule AttendanceServiceWeb.PageController do
  use AttendanceServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", message: "Hello")
  end
end
