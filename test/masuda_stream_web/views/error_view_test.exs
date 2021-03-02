defmodule MasudaStreamWeb.ErrorViewTest do
  use MasudaStreamWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(MasudaStreamWeb.ErrorView, "404.html", []) == "Page not found"
  end

  test "renders 500.html" do
    assert render_to_string(MasudaStreamWeb.ErrorView, "500.html", []) == "Internal server error"
  end
end
