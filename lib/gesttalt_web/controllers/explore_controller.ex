defmodule GesttaltWeb.ExploreController do
  use GesttaltWeb, :controller

  import GesttaltWeb.MetaTagsPlug

  def index(conn, _params) do
    conn
    |> put_meta_tags(%{
      title: "Explore",
      description: "Discover gardens, ideas, and connections in the Gesttalt community"
    })
    |> render(:index)
  end
end
