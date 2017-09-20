defmodule YoemberWeb.ErrorViewTest do
  use YoemberWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(YoemberWeb.ErrorView, "404.json", []) ==
           %{errors: %{message: "Page not found"}, meta: %{authors: "LugaTeX Inc.", licence: "CC-0"}}
  end

  test "render 500.json" do
    assert render(YoemberWeb.ErrorView, "500.json", []) ==
           %{errors: %{message: "Server Error"}, meta: %{authors: "LugaTeX Inc.", licence: "CC-0"}}
  end

  test "render any other" do
    assert render(YoemberWeb.ErrorView, "505.json", []) ==
           %{errors: %{message: "Server Error"}, meta: %{authors: "LugaTeX Inc.", licence: "CC-0"}}
  end
end
