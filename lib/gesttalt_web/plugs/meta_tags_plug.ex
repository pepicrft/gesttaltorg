defmodule GesttaltWeb.MetaTagsPlug do
  @moduledoc """
  Plug for managing HTML meta tags throughout the application.

  This plug initializes default meta tags and provides functions
  to set custom meta tags in controllers.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    default_meta = %{
      title: "Gesttalt",
      title_suffix: " · Gesttalt",
      description: "A platform for cultivating gardens of knowledge and growing ideas together",
      keywords: "knowledge management, digital garden, idea cultivation, collaborative learning",
      og_type: "website",
      og_site_name: "Gesttalt",
      twitter_card: "summary_large_image"
    }

    assign(conn, :meta_tags, default_meta)
  end

  @doc """
  Sets meta tags for the current request.

  ## Examples

      conn
      |> put_meta(:title, "Garden Journal")
      |> put_meta(:description, "Stories from our knowledge gardening community")
  """
  def put_meta(conn, key, value) when is_atom(key) do
    meta_tags = Map.put(conn.assigns.meta_tags, key, value)
    assign(conn, :meta_tags, meta_tags)
  end

  @doc """
  Sets multiple meta tags at once.

  ## Examples

      conn
      |> put_meta_tags(%{
        title: "Welcome to Gesttalt",
        description: "Start cultivating your digital garden today"
      })
  """
  def put_meta_tags(conn, tags) when is_map(tags) do
    meta_tags = Map.merge(conn.assigns.meta_tags, tags)
    assign(conn, :meta_tags, meta_tags)
  end

  @doc """
  Gets the full title with suffix.
  """
  def full_title(%{assigns: %{meta_tags: meta_tags}}) do
    case meta_tags do
      %{title: title, title_suffix: suffix} -> title <> suffix
      %{title: title} -> title
      _ -> "Gesttalt"
    end
  end
end
