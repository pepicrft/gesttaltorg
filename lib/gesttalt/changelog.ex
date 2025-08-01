defmodule Gesttalt.Changelog.Entry do
  @moduledoc """
  A changelog entry.

  This module defines the structure for changelog entries parsed from markdown files.
  """

  @enforce_keys [:version, :title, :body, :description, :categories, :date]
  defstruct [:version, :title, :body, :description, :categories, :date]

  def build(filename, attrs, body) do
    [year, month_day_version] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, version] = String.split(month_day_version, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    # Default values
    description = attrs[:description] || extract_description(body)
    categories = attrs[:categories] || ["general"]

    struct!(__MODULE__,
      version: version,
      title: attrs[:title],
      body: body,
      description: description,
      categories: categories,
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

defmodule Gesttalt.Changelog do
  @moduledoc """
  Changelog module for Gesttalt using NimblePublisher.

  This module handles changelog entries, including parsing markdown files
  for version updates, feature announcements, and bug fixes.
  """

  use NimblePublisher,
    build: __MODULE__.Entry,
    from: Application.app_dir(:gesttalt, "priv/changelog/**/*.md"),
    as: :entries,
    highlighters: [:makeup_elixir, :makeup_erlang]

  alias __MODULE__.Entry

  # The @entries variable is first transformed by NimblePublisher.
  # Let's further transform it by sorting all entries by descending date.
  @entries Enum.sort_by(@entries, & &1.date, {:desc, Date})

  # Let's also get all tags/categories
  @categories @entries |> Enum.flat_map(& &1.categories) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_entries, do: @entries
  def all_categories, do: @categories

  def recent_entries(count \\ 10) do
    Enum.take(@entries, count)
  end

  def get_entry_by_version!(version) do
    Enum.find(@entries, &(&1.version == version)) ||
      raise "changelog entry with version=#{version} not found"
  end

  def get_entries_by_category!(category) do
    case Enum.filter(@entries, &(category in &1.categories)) do
      [] -> raise "changelog entries with category=#{category} not found"
      entries -> entries
    end
  end
end
