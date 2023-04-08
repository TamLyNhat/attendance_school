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
          :duplicate_bag,
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
    def handle_cast({:delete, object}, any) do
      :ets.delete_object(:user_info, object)
      {:noreply, any}
    end

    @impl true
    def handle_cast({:update_checkout, data}, any) do
      {user_name, school_name, temperature, image, timestamp, _} = data
      :ets.delete_object(:user_info, data)
      :ets.insert(:user_info, {user_name, school_name, temperature, image,
                  timestamp, "check_out"})
      {:noreply, any}
    end

    @impl true
    def handle_call({:get_user, {user_name, school_name}}, _from, any) do
      user = :ets.match_object(:user_info, {user_name, school_name, :_, :_, :_,
                               :_})
      {:reply, user, any}
    end

    def handle_call({:get_user, {school_name}}, _from, any) do
      user = :ets.match_object(:user_info, {:_, school_name, :_, :_, :_, :_})
      {:reply, user, any}
    end

    @impl true
    def terminate(_reason, _any) do
      :ok
    end

    defp clean_up() do
      :ets.delete_all_objects(:user_info)
    end

end
