defmodule GesttaltWeb.BlogController do
  use GesttaltWeb, :controller

  alias Gesttalt.Blog
  import GesttaltWeb.MetaTagsPlug

  def index(conn, _params) do
    posts = Blog.all_posts()
    
    conn
    |> put_meta_tags(%{
      title: "Garden Journal",
      description: "Stories from our knowledge gardening community, cultivation techniques, and insights from tending digital gardens.",
      keywords: "digital garden, knowledge management, ideas, learning, community"
    })
    |> render(:index, posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post_by_id!(id)
    
    conn
    |> put_meta_tags(%{
      title: post.title,
      description: post.description,
      keywords: Enum.join(post.tags, ", "),
      og_type: "article"
    })
    |> render(:show, post: post)
  end

  def rss(conn, _params) do
    posts = Blog.recent_posts(20)
    
    conn
    |> put_resp_content_type("application/rss+xml")
    |> put_root_layout(false)
    |> put_view(GesttaltWeb.BlogHTML)
    |> render(:rss, posts: posts, layout: false)
  end

  def atom(conn, _params) do
    posts = Blog.recent_posts(20)
    
    conn
    |> put_resp_content_type("application/atom+xml")
    |> put_root_layout(false)
    |> put_view(GesttaltWeb.BlogHTML)
    |> render(:atom, posts: posts, layout: false)
  end
end