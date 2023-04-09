defmodule AttendanceServiceWeb.HighFeverView do
  use AttendanceServiceWeb, :live_view


  def render(_, assigns) do
    ~H"""
    <div>
            <label>total users: <%= @options.total_data %> </label>
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
                      <th> <%= user_id %></th>
                      <th> <%= user_name %></th>
                      <th> <%= school %></th>
                      <th> <%= temp %></th>
                    </tr>
                <% end %>
            </table>
            <button phx-click="previous" phx-value-page={@options.page_num - 1}>
              Previous
            </button>
            <button phx-click="next" phx-value-page={@options.page_num + 1}>
              Next
            </button>
        </div>
    """
  end
end
