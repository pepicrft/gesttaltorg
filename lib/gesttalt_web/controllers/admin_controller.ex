defmodule GesttaltWeb.AdminController do
  use GesttaltWeb, :controller

  import GesttaltWeb.Authorization
  import GesttaltWeb.MetaTagsPlug

  alias Gesttalt.Accounts

  def index(conn, _params) do
    conn = require_admin!(conn)

    if conn.halted do
      conn
    else
      users = Accounts.list_users()

      stats = %{
        total_users: length(users),
        confirmed_users: Enum.count(users, & &1.confirmed_at),
        admin_users: Enum.count(users, & &1.is_admin)
      }

      conn
      |> put_meta_tags(%{
        title: "Admin Dashboard",
        description: "Gesttalt instance administration"
      })
      |> render(:index, users: users, stats: stats)
    end
  end
end
