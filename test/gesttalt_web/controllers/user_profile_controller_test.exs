defmodule GesttaltWeb.UserProfileControllerTest do
  use GesttaltWeb.ConnCase, async: true

  import Gesttalt.AccountsFixtures

  describe "GET /:handle" do
    test "renders user profile page for existing user", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/#{user.handle}")
      response = html_response(conn, 200)

      assert response =~ "@#{user.handle}"
      assert response =~ user.email
      assert response =~ "Welcome to your profile!"
      assert response =~ "Account Settings"
      assert response =~ "Log out"
    end

    test "returns 404 for non-existent user", %{conn: conn} do
      conn = get(conn, ~p"/nonexistent")
      assert response(conn, 404)
    end

    test "renders confirmed status for confirmed user", %{conn: conn} do
      user =
        user_fixture()
        |> Ecto.Changeset.change(confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second))
        |> Gesttalt.Repo.update!()

      conn = get(conn, ~p"/#{user.handle}")
      response = html_response(conn, 200)

      assert response =~ "Confirmed"
    end

    test "renders unconfirmed status for unconfirmed user", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/#{user.handle}")
      response = html_response(conn, 200)

      assert response =~ "Unconfirmed"
    end
  end
end
