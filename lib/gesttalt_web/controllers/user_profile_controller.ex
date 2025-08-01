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
        # Check if viewing own profile
        current_user = conn.assigns[:current_user]
        is_own_profile = current_user && current_user.id == user.id
        render(conn, :show, user: user, is_own_profile: is_own_profile, page_title: "@#{user.handle}")
    end
  end

  def manage(conn, %{"handle" => handle}) do
    case Accounts.get_user_by_handle(handle) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(GesttaltWeb.ErrorHTML)
        |> render(:"404")

      user ->
        # Check if the current user is managing their own profile
        current_user = conn.assigns[:current_user]

        if current_user && current_user.id == user.id do
          render(conn, :manage, user: user, page_title: "Manage @#{user.handle}")
        else
          conn
          |> put_status(:forbidden)
          |> put_view(GesttaltWeb.ErrorHTML)
          |> render(:"403")
        end
    end
  end
end
