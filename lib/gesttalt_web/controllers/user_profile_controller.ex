defmodule GesttaltWeb.UserProfileController do
  use GesttaltWeb, :controller

  alias Gesttalt.Accounts

  def show(conn, %{"handle" => handle}) do
    case Accounts.get_user_by_handle(handle) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(GesttaltWeb.ErrorHTML)
        |> render(:"404")

      user ->
        render(conn, :show, user: user, page_title: "@#{user.handle}")
    end
  end

  def manage(conn, %{"handle" => handle}) do
    current_user = conn.assigns.current_user
    
    # Ensure user can only manage their own profile
    if current_user && current_user.handle == handle do
      render(conn, :manage, user: current_user, page_title: "Manage @#{current_user.handle}")
    else
      conn
      |> put_status(:forbidden)
      |> put_view(GesttaltWeb.ErrorHTML)
      |> render(:"403")
    end
  end
end
