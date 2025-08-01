defmodule GesttaltWeb.ChangelogHTML do
  @moduledoc """
  This module contains pages rendered by ChangelogController.
  """

  use GesttaltWeb, :html

  embed_templates "changelog_html/*"

  def format_date(date) do
    Calendar.strftime(date, "%B %d, %Y")
  end

  def category_emoji(category) do
    case category do
      "feature" -> "✨"
      "bugfix" -> "🐛"
      "improvement" -> "⚡"
      "security" -> "🔒"
      "breaking" -> "💥"
      "deprecation" -> "⚠️"
      "release" -> "🚀"
      _ -> "📝"
    end
  end
end
