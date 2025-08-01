defmodule GesttaltWeb.PageController do
  use GesttaltWeb, :controller

  import GesttaltWeb.MetaTagsPlug

  def index(conn, _params) do
    # Redirect based on authentication status
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/home")
    else
      redirect(conn, to: ~p"/explore")
    end
  end

  def home(conn, _params) do
    # Authenticated users' home feed
    conn
    |> put_meta_tags(%{
      title: "Home",
      description: "Your personal garden dashboard - nurture your ideas and explore connections."
    })
    |> render(:home)
  end
end
