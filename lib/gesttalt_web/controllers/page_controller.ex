defmodule GesttaltWeb.PageController do
  use GesttaltWeb, :controller
  
  import GesttaltWeb.MetaTagsPlug

  def index(conn, _params) do
    # If user is authenticated, redirect to home like Mastodon
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/home")
    else
      conn
      |> put_meta_tags(%{
        title: "Welcome to Gesttalt",
        description: "Cultivate your digital garden, connect ideas, and grow knowledge together in our collaborative platform."
      })
      |> render(:index)
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
