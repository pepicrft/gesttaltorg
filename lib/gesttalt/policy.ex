defmodule Gesttalt.Policy do
  @moduledoc """
  Main authorization policy module for Gesttalt.

  This module defines the authorization rules for the application
  using the Let Me authorization framework.
  """

  use LetMe.Policy

  # Define user as an object that can be authorized
  object :user do
    # Users can view any profile
    action :view do
      allow(:anyone)
    end

    # Users can only edit their own profile
    action :edit do
      allow(:owner)
    end

    # Users can only manage their own profile
    action :manage do
      allow(:owner)
    end
  end
end

defmodule Gesttalt.Policy.Checks do
  @moduledoc """
  Authorization check functions for Let Me.

  This module contains the actual check implementations
  referenced in the Policy module.
  """

  alias Gesttalt.Accounts.User

  def role(%User{is_admin: true}, _object, :admin), do: true
  def role(_actor, _object, _role), do: false

  def owner(actor, object, _action) do
    case {actor, object} do
      {%User{id: actor_id}, %User{id: resource_id}} when actor_id == resource_id ->
        true

      {%User{id: actor_id}, %{user_id: resource_user_id}} when actor_id == resource_user_id ->
        true

      _ ->
        false
    end
  end

  def anyone(_actor, _object, _action), do: true

  def member(_actor, _resource, _action), do: false
end
