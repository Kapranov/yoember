defmodule YoemberWeb.ErrorView do
  use YoemberWeb, :view

  def render("401.json", _assigns) do
    %{
      errors: %{message: "Unauthorized"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("403.json", _assigns) do
    %{
      errors: %{message: "Forbidden"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("404.json", _assigns) do
    %{
      errors: %{message: "Page not found"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("422.json", _assigns) do
    %{
      errors: %{message: "Unprocessable entity"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("500.json", _assigns) do
    %{
      errors: %{message: "Server Error"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
