defmodule GesttaltWeb.ChangelogController do
  use GesttaltWeb, :controller

  alias Gesttalt.Changelog
  import GesttaltWeb.MetaTagsPlug

  def index(conn, _params) do
    entries = Changelog.all_entries()
    
    conn
    |> put_meta_tags(%{
      title: "Changelog",
      description: "Track the growth and evolution of Gesttalt - new features, improvements, and bug fixes."
    })
    |> render(:index, entries: entries)
  end

  def show(conn, %{"version" => version}) do
    entry = Changelog.get_entry_by_version!(version)
    
    conn
    |> put_meta_tags(%{
      title: "#{entry.title} - v#{entry.version}",
      description: entry.excerpt
    })
    |> render(:show, entry: entry)
  end
end