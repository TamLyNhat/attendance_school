defmodule AttendanceServiceWeb.UserController do
  use AttendanceServiceWeb, :controller
  alias AttendanceService.Accounts.Users
  alias AttendanceService.Accounts
  alias AttendanceService.StorageService.ApiUser

  @server :storage_server

  @doc """
  Load new.html for check-in page.
  """
  def new(conn, _params) do
    changeset = Accounts.change_user(%Users{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Load check-out.html for check-out page.
  """
  def check_out(conn, _params) do
    changeset = Accounts.change_user(%Users{})
    render(conn, "check_out.html", changeset: changeset)
  end

  @doc """
  Handle error when user is empty.
  """
  def check(conn,  %{"users" => %{"user_id" => ""}}) do
    changeset = Accounts.change_user(%Users{})

    conn
    |> put_flash(:info, "wrong input!")
    |> render("check_out.html", changeset: changeset)
  end

  @doc """
  Change type to check-out if user is created into the system, otherwise
  notification will report.
  """
  def check(conn,  %{"users" => %{"user_id" => user_id}}) do
    try do
      case ApiUser.get_user_base_on_id(@server, {:key,
                                      String.to_integer(user_id)}) do
        [] ->
          conn
          |> put_flash(:info, "Wrong user id or you did not created account yet.")
          |> redirect(to: Routes.user_path(conn, :check_out))
        [data] ->
          ApiUser.update_checkout(@server, data)
          conn
          |> put_flash(:info, "checkout sucessfully !")
          |> redirect(to: Routes.user_path(conn, :check_out))
      end
    rescue
      ArgumentError ->
        conn
        |> put_flash(:error, "Wrong format! You should type number of user_id")
        |> redirect(to: Routes.user_path(conn, :check_out))
    end
  end

  @doc """
  Create user
  """
  def create(conn, %{"users" => %{"user_name" => user_name,
                                  "school_name" => school_name,
                                  "temperature" => temperature,
                                  "file_name" => file_name} =
             user_params}) do
    timestamps = :calendar.local_time()
    type = "check-in"
    %{filename: filename, content_type: _content_type, path: path} = file_name
    case Accounts.check_changeset(Users.changeset(%Users{}, user_params)) do
      :ok ->
        new_file_name = Accounts.get_image_info(filename, path)
        insert_and_redirect(conn, user_name, school_name, temperature,
                            new_file_name, timestamps, type)
      {:error, {:error, %Ecto.Changeset{} = changeset}} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Handle negative case when image is not selected
  """
  def create(conn, _user_params) do
    changeset = Accounts.change_user(%Users{})

    conn
    |> put_flash(:info, "Need to choose image!")
    |> render("new.html", changeset: changeset)
  end

  @doc """
  Insert user with random user_id, if there is same user_id in the database,
  new user_id will be populate again.
  """
  def insert_and_redirect(conn, user_name, school_name, temperature,
                          new_file_name, timestamps, type) do
    key_random = Enum.random(0..1000000000)
    case ApiUser.get_user_base_on_id(@server, {:key, key_random}) do
      [] ->
        ApiUser.insert(@server, {key_random, user_name, school_name, temperature,
                                 new_file_name, timestamps, type})
        conn
        |> put_flash(:info, "remember #{key_random} id number and use it for"
                     <> " when check-out")
        |> redirect(to: Routes.user_path(conn, :new))
      _ ->
        insert_and_redirect(conn, user_name, school_name, temperature,
                            new_file_name, timestamps, type)
    end
  end
end
