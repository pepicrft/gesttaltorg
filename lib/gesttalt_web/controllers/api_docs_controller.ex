defmodule GesttaltWeb.ApiDocsController do
  use GesttaltWeb, :controller

  def show(conn, _params) do
    spec = GesttaltWeb.ApiSpec.spec()
    render(conn, :show, spec: spec)
  end
end
