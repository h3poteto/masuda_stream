defmodule MasudaStreamWeb.PageControllerTest do
  use MasudaStreamWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~
             "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"utf-8\"/>\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"/>\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\n    <title>MasudaStream</title>\n    <link href=\"https://fonts.googleapis.com/earlyaccess/roundedmplus1c.css\" rel=\"stylesheet\" />\n  </head>\n  <body>\n<div id=\"app\">\n  <router-view></router-view>\n</div>\n    <script type=\"text/javascript\" src=\"/js/app.js\"></script>\n  </body>\n</html>\n"
  end
end
