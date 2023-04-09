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
    Users.add_sample_data()
    data = ApiUser.get_higher_fever(:storage_server, {:get_higher_fever,
                                    "aaaa"})
    filter_data = Users.get_list_on_page(1, data)
    total_data = Enum.count(data)
    max_page =
      total_data/5 |>
      Decimal.from_float |>
      Decimal.round(0, :up) |>
      Decimal.to_integer()

    {:ok, assign(socket, options: %{page_num: 1, filter_data: filter_data,
                 total_data: total_data, data: data, max_page: max_page})}
  end


  @impl true
  def handle_event("previous", %{"page" => "0"}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("previous", %{"page" => current_page}, socket) do
    previous_page = String.to_integer(current_page)
    data = socket.assigns.options.data
    new_filter_data = Users.get_list_on_page(previous_page, data)
    total_data = socket.assigns.options.total_data
    max_page = socket.assigns.options.max_page
    {:noreply, assign(socket, options: %{page_num: previous_page,
                      filter_data: new_filter_data,
                      total_data: total_data, data: data, max_page: max_page})}
  end

  @impl true
  def handle_event("next", %{"page" => current_page}, socket) do
    next_page = String.to_integer(current_page)
    case next_page > socket.assigns.options.max_page do
       true ->
         {:noreply, socket}
       false ->
         data = socket.assigns.options.data
         max_page = socket.assigns.options.max_page
         new_filter_data = Users.get_list_on_page(next_page, data)
         total_data = socket.assigns.options.total_data
         {:noreply, assign(socket, options: %{page_num: next_page,
                           filter_data: new_filter_data,
                           total_data: total_data, data: data,
                           max_page: max_page})}
    end

  end


end
