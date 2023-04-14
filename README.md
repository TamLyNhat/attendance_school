## Instruction to run the apps
* Prerequisites: erlang/otp 25, elixir 1.14.1, docker, nodejs 18.12.0

Create docker by command:
+ For postgres:
`docker run -p 5432:5432 --name container-postgresdb -e POSTGRES_PASSWORD=admin -d postgres:13.9`
+ For pgadmin:
`docker run -p 5050:80  -e "PGADMIN_DEFAULT_EMAIL=name@example.com" -e "PGADMIN_DEFAULT_PASSWORD=admin"  -d dpage/pgadmin4`
+ Go to gui: http://localhost:5050/browser/ with user name: name@example.com and password:admin
+ Register new server, name:postgres, host name/address your ip laptop, port: 5432, maintenance database: postgres, username: postgres, password:admin

Gets all out of date dependencies:
```
mix deps.get
```
Building phoenix.js
```bash
cd assets
npm install
```

To start your Phoenix server:
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Check-out these path for using the feature of apps:
  + `localhost:4000/users/new`: create new user with default check-in type.
  + `localhost:4000/users/check_out`: checkout for this user, only change type to checkout.
  + `localhost:4000/highfever`: High fever events, distributed by school with temperature of student higher than 38 degree.
  + `localhost:4000/attendance_aggregated`: School attendance aggregated by day / week / month (present, absent) (not finish yet)


## App architecture:
Architecture of apps bases on model/view/controller, and I use Liveview for realtime handling, it will not need to reload the page in order to update new data.
Database: I use ets table for storing the data.
Name of table: :user_info, it has term like this:
{user_id, user_name, school_name, temperature, image, timestamp, type}

```
user_id: id of student, type: integer()
user_name: name of student, type: string()
school_name: name of school, type: string()
temperature: temperature of student type: integer()
image: image of student, it will have the format {binary, name}, when we save the image of student, we will encode it to binary and store with the name, when we use it, we will decode binary to picture with the name and show in the dashboard.
timestamp: time of student when they check-in and check-out, type: tuple()
type: check-in or check-out, type: string()
```

Regarding docker and postgres, I installed postgres into docker and create table inside the postgres database Ecto and create Ecto.Schema for users.

I created `storage_server` to interact action between database and external interface, it is developed based on `GenServer` strategy.

Main controller:
 + user_controller.ex: handle check-in, check-out functionalities for users
 + high_fever_controller.ex: it shows data distributed by school, and get users have temperature higher than  38 degree, then populate data to dashboard, when start the page, it will add example data to database at TypeSelect.mount/1. It also have pagination feature. f


## Proud features
Probably, I am proud for every line code I wrote, because of for each line code, I need to spent a lot of time to think how to write it, sometimes need to debug when it crash, and figure the reason out.
## Incompleted feature
* School attendance aggregated by day / week / month (present, absent) => I have developed somethings for this one, separated 3 live components(AttendanceServiceWeb.TypeSelect, AttendanceServiceWeb.DayWeekOrMonth, AttendanceServiceWeb.ShowDataAttendance), one for selecting the type (day/week/month), one for one for handling day/week/month event when TypeSelect LiveComponenent sent the coresponding event, last one for populating the data for day/week/month, I am done for TypeSelect LiveComponenent, need to handle data between DayWeekOrMonth and ShowDataAttendance LiveComponenent.
* Providing script to populate fake data when server is running (you can used name generator tools) => not finish yet.

The reason why it did not finish yet because I do not have enough time to play with thoses, need to spend more time.

## Link reference

  * [Ets table](https://www.erlang.org/doc/man/ets.html).
  * [Hex packages documentation](https://hexdocs.pm/).
  * [Stackoverflow for searching the bug fix](https://stackoverflow.com/).
  * [elixirforum for searching the bug fix](https://elixirforum.com/).
  * [Elixir documentation](https://elixir-lang.org/).
  * [Erlang documentation](https://www.erlang.org/doc/).


