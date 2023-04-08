defmodule AttendanceService.Repo do
  use Ecto.Repo,
    otp_app: :attendance_service,
    adapter: Ecto.Adapters.Postgres
end
