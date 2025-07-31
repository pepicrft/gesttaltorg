defmodule GesttaltWeb.PageControllerTest do
  use GesttaltWeb.ConnCase

  test "GET / shows navigation and footer for non-authenticated users", %{conn: conn} do
    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    # Should show the main content
    assert response =~ "Gesttalt"
    assert response =~ "A tool of expression on the Internet"
    assert response =~ "Sign up"
    assert response =~ "Log in"

    # Should show navigation for non-authenticated users
    assert response =~ "About"
    assert response =~ "Explore"

    # Should show footer
    assert response =~ "Mobile"
    assert response =~ "iOS App"
    assert response =~ "Android App"
    assert response =~ "Developers"
    assert response =~ "Browser Extensions"
    assert response =~ "API"
    assert response =~ "Source Code"
  end
end
