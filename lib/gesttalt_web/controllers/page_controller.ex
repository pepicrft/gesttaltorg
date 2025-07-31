defmodule GesttaltWeb.PageController do
  use GesttaltWeb, :controller

  def index(conn, _params) do
    # If user is authenticated, redirect to home like Mastodon
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/home")
    else
      render(conn, :index)
    end
  end

  def home(conn, _params) do
    # Authenticated users' home feed
    render(conn, :home)
  end
end
