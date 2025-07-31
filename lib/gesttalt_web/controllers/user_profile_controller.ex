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
end
