defmodule GesttaltWeb.Authorization do
  @moduledoc """
  Authorization helpers for Phoenix controllers.

  This module provides convenient functions for checking
  authorization in controllers using Let Me.
  """

  import Phoenix.Controller
  import Plug.Conn

  alias Gesttalt.Accounts.User
  alias Gesttalt.Policy

  @doc """
  Authorizes an action or halts the connection with a 403 Forbidden response.

  ## Examples

      authorize!(conn, :admin_dashboard, :access)
      authorize!(conn, user_profile, :edit)
  """
  def authorize!(conn, object, action) do
    actor = conn.assigns[:current_user]

    # For Let Me, we need to pass the object type explicitly
    result =
      case object do
        %User{} ->
          Policy.authorize(action, actor, object, :user)

        _ ->
          Policy.authorize(action, actor, object)
      end

    case result do
      :ok ->
        conn

      {:error, _reason} ->
        conn
        |> put_status(:forbidden)
        |> put_view(GesttaltWeb.ErrorHTML)
        |> render(:"403")
        |> halt()
    end
  end

  @doc """
  Checks if an action is authorized.

  ## Examples

      if authorized?(conn, user_profile, :edit) do
        # Show edit button
      end
  """
  def authorized?(conn, object, action) do
    actor = conn.assigns[:current_user]

    # For Let Me, we need to pass the object type explicitly
    result =
      case object do
        %User{} ->
          Policy.authorize(action, actor, object, :user)

        _ ->
          Policy.authorize(action, actor, object)
      end

    case result do
      :ok -> true
      {:error, _reason} -> false
    end
  end

  @doc """
  Checks if the current user is an admin.
  """
  def admin?(conn) do
    case conn.assigns[:current_user] do
      nil -> false
      user -> user.is_admin == true
    end
  end

  @doc """
  Ensures the current user is an admin or halts with 403.
  """
  def require_admin!(conn) do
    if admin?(conn) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(GesttaltWeb.ErrorHTML)
      |> render(:"403")
      |> halt()
    end
  end
end
