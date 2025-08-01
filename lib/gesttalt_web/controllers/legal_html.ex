defmodule GesttaltWeb.LegalHTML do
  @moduledoc """
  This module contains pages rendered by LegalController.
  """

  use GesttaltWeb, :html

  embed_templates "legal_html/*"
end