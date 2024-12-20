defmodule CliveWeb.ErrorJSONTest do
  use CliveWeb.ConnCase, async: true

  test "renders 404" do
    assert CliveWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CliveWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
