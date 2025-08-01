defmodule Gesttalt.Blog.Post do
  @moduledoc """
  A blog post.

  This module defines the structure for blog posts parsed from markdown files.
  """

  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date]
  defstruct [:id, :author, :title, :body, :description, :tags, :date]

  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    # Default values
    author = attrs[:author] || "Gesttalt Team"
    description = attrs[:description] || extract_description(body)
    tags = attrs[:tags] || []

    struct!(__MODULE__,
      id: id,
      author: author,
      title: attrs[:title],
      body: body,
      description: description,
      tags: tags,
      date: date
    )
  end

  defp extract_description(body) do
    body
    |> String.split("\n\n", parts: 2)
    |> hd()
    |> String.slice(0, 160)
    |> String.trim()
  end
end

defmodule Gesttalt.Blog do
  @moduledoc """
  Blog module for Gesttalt using NimblePublisher.

  This module handles blog posts, including parsing markdown files,
  generating RSS/Atom feeds, and providing an interface for the blog.
  """

  use NimblePublisher,
    build: __MODULE__.Post,
    from: Application.app_dir(:gesttalt, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  alias __MODULE__.Post

  # The @posts variable is first transformed by NimblePublisher.
  # Let's further transform it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags

  def recent_posts(count \\ 5) do
    Enum.take(@posts, count)
  end

  def get_post_by_id!(id) do
    Enum.find(@posts, &(&1.id == id)) ||
      raise "post with id=#{id} not found"
  end

  def get_posts_by_tag!(tag) do
    case Enum.filter(@posts, &(tag in &1.tags)) do
      [] -> raise "posts with tag=#{tag} not found"
      posts -> posts
    end
  end
end
