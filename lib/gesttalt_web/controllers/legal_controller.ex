defmodule GesttaltWeb.LegalController do
  use GesttaltWeb, :controller
  
  import GesttaltWeb.MetaTagsPlug

  def terms(conn, _params) do
    conn
    |> put_meta_tags(%{
      title: "Terms of Service",
      description: "Terms and conditions for using Gesttalt - our digital gardening platform."
    })
    |> render(:terms)
  end

  def privacy(conn, _params) do
    conn
    |> put_meta_tags(%{
      title: "Privacy Policy",
      description: "How Gesttalt protects your privacy and handles your data."
    })
    |> render(:privacy)
  end

  def cookies(conn, _params) do
    conn
    |> put_meta_tags(%{
      title: "Cookie Policy",
      description: "How Gesttalt uses cookies to improve your experience."
    })
    |> render(:cookies)
  end
end