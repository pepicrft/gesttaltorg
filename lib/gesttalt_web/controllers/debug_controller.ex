defmodule GesttaltWeb.DebugController do
  use GesttaltWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
