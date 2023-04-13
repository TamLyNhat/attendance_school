defmodule AttendanceService.StorageService.ApiUser do
  require Logger

  @doc """
  Insert new element into table
  """
  @spec insert(:storage_server, tuple()) :: :ok
  def insert(server, element) do
    fun = &GenServer.cast(&1, {:post, element})
    exec_func(server, fun)
  end

  @doc """
  Delete single record in the table
  """
  @spec delete(:storage_server, atom()) :: :ok
  def delete(server, element) do
    fun = &GenServer.cast(&1, {:delete, element})
    exec_func(server, fun)
  end

  @doc """
  Update user type info when they check-out
  """
  @spec update_checkout(:storage_server, tuple()) :: :ok
  def update_checkout(server, element) do
    fun = &GenServer.cast(&1, {:update_checkout, element})
    exec_func(server, fun)
  end

  @doc """
  Get user term info base on user_name and school_name
  """
  @spec get_user(:storage_server,  tuple()) :: list()
  def get_user(server, {_user_name, _school_name} = object) do
    fun = &GenServer.call(&1, {:get_user, object})
    exec_func(server, fun)
  end

  @doc """
  Get user term info base on school_name
  """
  @spec get_user_base_on_sc(:storage_server,  tuple()) :: list()
  def get_user_base_on_sc(server, {_school_name} = object) do
    fun = &GenServer.call(&1, {:get_user, object})
    exec_func(server, fun)
  end

  @doc """
  Get user term info base on user_id
  """
  @spec get_user_base_on_id(:storage_server,  tuple()) :: list()
  def get_user_base_on_id(server, {:key, _user_id} = object) do
    fun = &GenServer.call(&1, {:get_user, object})
    exec_func(server, fun)
  end

  @doc """
  Get high fever users by school when temperature higher than 38 degree
  """
  @spec get_higher_fever(:storage_server,  tuple()) :: list()
  def get_higher_fever(server, {:get_higher_fever, school_name}) do
    fun = &GenServer.call(&1, {:get_higher_fever, school_name})
    exec_func(server, fun)
  end

  @doc """
  Get list school
  """
  @spec get_list_school(:storage_server) :: list()
  def get_list_school(server) do
    fun = &GenServer.call(&1, {:get_list_school})
    exec_func(server, fun)
  end

  @doc """
  Get list users
  """
  @spec get_list_users(:storage_server) :: list()
  def get_list_users(server) do
    fun = &GenServer.call(&1, {:get_list_users})
    exec_func(server, fun)
  end

  defp exec_func(_server, :ok) do
    :ok
  end

  defp exec_func(server, fun) do
    case :global.whereis_name(server) do
      :undefined ->
        Logger.warn("#{inspect(server)} died !")
        :ok
      pid ->
        fun.(pid)
    end
  end
end
