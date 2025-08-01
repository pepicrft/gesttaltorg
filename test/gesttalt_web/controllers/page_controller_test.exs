defmodule GesttaltWeb.PageControllerTest do
  use GesttaltWeb.ConnCase
  
  import Gesttalt.AccountsFixtures

  describe "GET /" do
    test "shows landing page for non-authenticated users", %{conn: conn} do
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)

      # Should show the main content
      assert response =~ "Gesttalt"
      assert response =~ "Plant seeds of ideas. Cultivate gardens of knowledge. Grow a better society together."
      assert response =~ "Start Gardening"
      assert response =~ "Tend Your Garden"

      # Should show navigation for non-authenticated users
      assert response =~ "Explore"
      assert response =~ "Log in"
      assert response =~ "Sign up"

      # Should show footer
      assert response =~ "Mobile"
      assert response =~ "iOS App"
      assert response =~ "Android App"
      assert response =~ "Developers"
      assert response =~ "API"
      assert response =~ "Source Code"
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
