defmodule AttendanceServiceWeb.ShowDataSchoolSelected do
  alias AttendanceService.Accounts.Users

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-target={@myself}>
          <div>
              <label>total users has temperature higher than 38 degree:
                   <%= @options.total_data %> users</label>
              <label>showing: 5 item</label>
              <label>page: <%= @options.page_num %>/<%= @options.max_page %>
              </label>
          </div>

          <div>
              <table>
                  <tr>
                      <th>user id</th>
                      <th>user name</th>
                      <th>school name</th>
                      <th>temperature</th>
                  </tr>
                  <%= for {user_id, user_name, school, temp, _image, _date, _type}
                      <- @options.filter_data do %>
                      <tr>
                          <th>
                              <%= user_id %>
                          </th>
                          <th>
                              <%= user_name %>
                          </th>
                          <th>
                              <%= school %>
                          </th>
                          <th>
                              <%= temp %>
                          </th>
                      </tr>
                      <% end %>
              </table>
              <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
              </form>
              <button phx-click="previous"
                  phx-value-page={@options.page_num - 1}>
                  Previous
              </button>
              <button phx-click="next" phx-value-page={@options.page_num + 1}>
                  Next
              </button>
          </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, options: %{page_num: 1, filter_data: [],
                 total_data: 0, data: [], max_page: 1})}
  end

  @doc """
  Receive data from AttendanceServiceWeb.HighFeverController and load data to
  live component
  """
  @impl true
  def update(%{action: {:load_data, msg}}, socket) do
    {filter_data, total_data, data, max_page} = msg

    {:ok, assign(socket, options: %{page_num: 1, filter_data: filter_data,
                 total_data: total_data, data: data, max_page: max_page})}
  end

  @doc """
  Get next 5 users and load to live component
  """
  def update(%{action: {:load_next, current_page}} = assigns, socket) do
    next_page = String.to_integer(current_page)
    case next_page > socket.assigns.options.max_page do
       true ->
        {:ok, assign(socket, assigns)}
       false ->
         data = socket.assigns.options.data
         max_page = socket.assigns.options.max_page
         new_filter_data = Users.get_list_on_page(next_page, data)
         total_data = socket.assigns.options.total_data
         {:ok, assign(socket, options: %{page_num: next_page, filter_data:
                      new_filter_data, total_data: total_data, data: data,
                      max_page: max_page})}
    end
  end

  @doc """
  Get previous 5 users and load to live component
  """
  def update(%{action: {:load_previous, current_page}}, socket) do
    previous_page = String.to_integer(current_page)
    data = socket.assigns.options.data
    new_filter_data = Users.get_list_on_page(previous_page, data)
    total_data = socket.assigns.options.total_data
    max_page = socket.assigns.options.max_page
    {:ok, assign(socket, options: %{page_num: previous_page,
                 filter_data: new_filter_data, total_data: total_data,
                 data: data, max_page: max_page})}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
