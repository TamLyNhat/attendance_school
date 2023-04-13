defmodule AttendanceServiceWeb.TypeSelect do
  use Phoenix.LiveComponent
  alias AttendanceService.Accounts.Users
  alias AttendanceService.StorageService.ApiUser

  @impl true
  def render(assigns) do
    ~H"""
    <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
                 phx-target={@myself} phx-change="change_type">
    <label>choose type you want to filter(date, week or month)</label>
    <select class="block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight
                        focus:outline-none focus:bg-white focus:border-gray-500" id="grid-state" name="search[change_type]">
         <%= for item <- @list do %>
            <option> <%= item %> </option>
         <% end %>
        </select>
    </form>
    """
  end

  @impl true
  def mount(socket) do
    list = ["date", "week", "month"]

    {:ok, assign(socket, list: list)}
  end

  @doc """
  Handle event change when click school name
  """
  require Logger
  @impl true
  def handle_event("change_type", params, socket) do
    Logger.debug("zlyxtam_debug_params__#{__MODULE__}__: #{inspect(params)}")

    send self(), {:search, params}
    {:noreply, socket}
  end

end
