defmodule GesttaltWeb.UserProfileControllerTest do
  use GesttaltWeb.ConnCase, async: true

  import Gesttalt.AccountsFixtures

  describe "GET /@:handle" do
    test "renders user profile page for existing user", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/@#{user.handle}")
      response = html_response(conn, 200)

      assert response =~ "@#{user.handle}"
    end

    test "returns 404 for non-existent user", %{conn: conn} do
      conn = get(conn, ~p"/@nonexistent")
      assert response(conn, 404)
    end
  end

  describe "GET /@:handle/manage" do
    test "renders manage page for authenticated user accessing their own profile", %{conn: conn} do
      user = user_fixture()
      conn = 
        conn
        |> log_in_user(user)
        |> get(~p"/@#{user.handle}/manage")
      
      response = html_response(conn, 200)
      assert response =~ "Manage Your Garden"
      assert response =~ "@#{user.handle}"
    end

    test "returns 403 for authenticated user trying to manage another user's profile", %{conn: conn} do
      user1 = user_fixture()
      user2 = user_fixture()
      
      conn = 
        conn
        |> log_in_user(user1)
        |> get(~p"/@#{user2.handle}/manage")
      
      assert response(conn, 403)
    end

    test "redirects to login for unauthenticated user", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/@#{user.handle}/manage")
      
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end
end
