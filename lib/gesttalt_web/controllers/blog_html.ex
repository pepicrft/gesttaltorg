defmodule GesttaltWeb.BlogHTML do
  @moduledoc """
  This module contains pages rendered by BlogController.
  """

  use GesttaltWeb, :html

  embed_templates "blog_html/*"

  def format_date(date) do
    Calendar.strftime(date, "%B %d, %Y")
  end

  def format_rfc2822(date) do
    {:ok, datetime} = DateTime.new(date, ~T[00:00:00])
    Calendar.strftime(datetime, "%a, %d %b %Y %H:%M:%S +0000")
  end

  def format_iso8601(date) do
    {:ok, datetime} = DateTime.new(date, ~T[00:00:00])
    DateTime.to_iso8601(datetime)
  end
end