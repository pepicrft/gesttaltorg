defmodule GesttaltWeb.PageControllerTest do
  use GesttaltWeb.ConnCase

  import Gesttalt.AccountsFixtures

  describe "GET /" do
    test "redirects non-authenticated users to /explore", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert redirected_to(conn) == ~p"/explore"
    end

    test "redirects authenticated users to /home", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/")

      assert redirected_to(conn) == ~p"/home"
    end
  end

  describe "GET /home" do
    test "shows home feed for authenticated users", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/home")

      response = html_response(conn, 200)
      assert response =~ "Your Garden"
      assert response =~ "Welcome back, @#{user.handle}"
      assert response =~ "Your feed is ready to bloom"
    end

    test "redirects unauthenticated users to login", %{conn: conn} do
      conn = get(conn, ~p"/home")
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end
end
