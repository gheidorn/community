defmodule CommunityWeb.NewsControllerTest do
  use CommunityWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "from Phoenix!"
    assert html_response(conn, 200) =~ "bootstrap.min.css"
  end
end
