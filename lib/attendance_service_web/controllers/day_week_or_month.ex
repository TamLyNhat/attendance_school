defmodule AttendanceServiceWeb.DayWeekOrMonth do
  use Phoenix.LiveComponent
  alias AttendanceService.Accounts.Users
  alias AttendanceService.StorageService.ApiUser
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
                 phx-target={@myself} phx-change="selected_type">
    <div>
      <%= if @info.type=="date" do %>
        <div>
          <label>Choose attendance aggregated by date</label>
          <input id="user_name" name="search[date]" type="date" value="">
        </div>
        <% end %>
        <%= if @info.type=="week" do %>
        <div>
            <label>Choose attendance aggregated by week</label>

            <select class="block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight
                    focus:outline-none focus:bg-white focus:border-gray-500" id="grid-state" name="search[week]">
              <%= for item <- @info.list_month do %>
                <option>
                  <%= item %>
                </option>
                <% end %>
            </select>
        </div>
        <% end %>
        <%= if @info.type=="month" do %>
          <div>
            <label>Choose attendance aggregated by month</label>
            <select class="block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight
                  focus:outline-none focus:bg-white focus:border-gray-500" id="grid-state" name="search[month]">
              <%= for item <- @info.list_week do %>
                <option>
                  <%= item %>
                </option>
                <% end %>
            </select>
          </div>
        <% end %>
    </div>
    </form>
    """
  end

  @impl true
  def mount(socket) do
    list_month = Enum.to_list(1..12)
    list_week = Enum.to_list(1..52)
    {:ok, assign(socket, info: %{list_month: list_month, list_week: list_week,
                 type: "date"})}
  end


  @doc """
  Handle event change when click school name
  """
  @impl true
  def handle_event("selected_type", %{"search" => %{"date" => date}}, socket) do
    [year, month, date] = String.split(date, ~r{-})
    new_list = [String.to_integer(year), String.to_integer(month), String.to_integer(date)]
    tuple_date = :erlang.list_to_tuple(new_list)

    send self(), {:selected_type, tuple_date}
    {:noreply, socket}
  end

  def handle_event("selected_type", %{"week" => week}, socket) do
    send self(), {:selected_type, week}
    {:noreply, socket}
  end

  @doc """
  Receive data from AttendanceServiceWeb.HighFeverController and load data to
  live component
  """
  @impl true
  def update(%{action: {:change_type, new_type}}, socket) do
    list_month = socket.assigns.info.list_month
    list_week = socket.assigns.info.list_week

    {:ok, assign(socket, info: %{list_month: list_month, list_week: list_week,
                 type: new_type})}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

end
