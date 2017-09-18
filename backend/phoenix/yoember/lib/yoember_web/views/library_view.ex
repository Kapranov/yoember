defmodule YoemberWeb.LibraryView do
  use YoemberWeb, :view
  alias YoemberWeb.LibraryView

  def render("index.json", %{libraries: libraries}) do
    %{data: render_many(libraries, LibraryView, "library.json")}
  end

  def render("show.json", %{library: library}) do
    %{data: render_one(library, LibraryView, "library.json")}
  end

  def render("library.json", %{library: library}) do
    %{id: library.id,
      name: library.name,
      address: library.address,
      phone: library.phone}
  end
end
