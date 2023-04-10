defmodule AttendanceService.StorageService.User do
    use GenServer
    require Logger

    @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
    @doc """
    Starts the server.
    """
    def start_link(name) do
      GenServer.start_link(__MODULE__, [], name: {:via, :global, name})
    end

    # Server (callbacks)

    @impl true
    def init(any) do
      :user_info =
        :ets.new(:user_info, [
          :ordered_set,
          :public,
          :named_table,
          {:write_concurrency, true},
          {:read_concurrency, true}
        ])
      {:ok, any}
    end

    @impl true
    def handle_info({:EXIT, _from, reason}, state) do
      Logger.warn("Exiting with reason: #{inspect(reason)}")
      clean_up()
      {:stop, reason, state}
    end

    @impl true
    def handle_cast({:post, element}, any) do
      :ets.insert(:user_info, element)
      {:noreply, any}
    end

    @impl true
    def handle_cast({:delete, key}, any) do
      :ets.delete(:user_info, key)
      {:noreply, any}
    end

    @impl true
    def handle_cast({:update_checkout, data}, any) do
      {user_id, user_name, school_name, temperature, image, timestamp, _} = data
      :ets.insert(:user_info, {user_id, user_name, school_name, temperature,
                  image, timestamp, "check_out"})
      {:noreply, any}
    end

    @impl true
    def handle_call({:get_user, {:key, user_id}}, _from, any) do
      user = :ets.lookup(:user_info, user_id)
      {:reply, user, any}
    end

    def handle_call({:get_user, {user_name, school_name}}, _from, any) do
      user = :ets.match_object(:user_info, {:_, user_name, school_name, :_, :_,
                               :_, :_})
      {:reply, user, any}
    end

    def handle_call({:get_user, {school_name}}, _from, any) do
      user = :ets.match_object(:user_info, {:_, :_, school_name, :_, :_, :_,
                               :_})
      {:reply, user, any}
    end

    def handle_call({:get_higher_fever, school_name}, _from, any) do
      users = :ets.select(:user_info, [{{:_, :_, school_name, :"$1", :_, :_,
                          :_}, [{:>, :"$1", 38}], [:"$_"]}])
      {:reply, users, any}
    end

    def handle_call({:get_list_school}, _from, any) do
      list_school =
        :ets.select(:user_info, [{{:_, :_, :"$1", :_, :_, :_, :_}, [], [:"$1"]}])
        |> Enum.uniq()
      {:reply, list_school, any}
    end

    @impl true
    def terminate(_reason, _any) do
      :ok
    end

    defp clean_up() do
      :ets.delete_all_objects(:user_info)
    end

end
