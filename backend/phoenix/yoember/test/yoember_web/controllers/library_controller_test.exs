defmodule YoemberWeb.LibraryControllerTest do
  use YoemberWeb.ConnCase

  #alias Yoember.Libraries
  #alias Yoember.Libraries.Library

  #@create_attrs %{address: "some address", name: "some name", phone: "some phone"}
  #@update_attrs %{address: "some updated address", name: "some updated name", phone: "some updated phone"}
  #@invalid_attrs %{address: nil, name: nil, phone: nil}

  #def fixture(:library) do
  #  {:ok, library} = Libraries.create_library(@create_attrs)
  #  library
  #end

  #setup %{conn: conn} do
  #  {:ok, conn: put_req_header(conn, "accept", "application/json")}
  #end

  #describe "index" do
  #  test "lists all libraries", %{conn: conn} do
  #    conn = get conn, library_path(conn, :index)
  #    assert json_response(conn, 200)["data"] == []
  #  end
  #end

  #describe "create library" do
  #  test "renders library when data is valid", %{conn: conn} do
  #   conn = post conn, library_path(conn, :create), library: @create_attrs
  #   assert %{"id" => id} = json_response(conn, 201)["data"]

  #   conn = get conn, library_path(conn, :show, id)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => id,
  #     "address" => "some address",
  #     "name" => "some name",
  #     "phone" => "some phone"}
  #  end

  #  test "renders errors when data is invalid", %{conn: conn} do
  #    conn = post conn, library_path(conn, :create), library: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #end

  #describe "update library" do
  #  setup [:create_library]

  #  test "renders library when data is valid", %{conn: conn, library: %Library{id: id} = library} do
  #    conn = put conn, library_path(conn, :update, library), library: @update_attrs
  #    assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #    conn = get conn, library_path(conn, :show, id)
  #    assert json_response(conn, 200)["data"] == %{
  #      "id" => id,
  #      "address" => "some updated address",
  #      "name" => "some updated name",
  #      "phone" => "some updated phone"}
  #  end

  #  test "renders errors when data is invalid", %{conn: conn, library: library} do
  #    conn = put conn, library_path(conn, :update, library), library: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #end

  #describe "delete library" do
  #  setup [:create_library]

  #  test "deletes chosen library", %{conn: conn, library: library} do
  #    conn = delete conn, library_path(conn, :delete, library)
  #    assert response(conn, 204)
  #    assert_error_sent 404, fn ->
  #      get conn, library_path(conn, :show, library)
  #    end
  #  end
  #end

  #defp create_library(_) do
  #  library = fixture(:library)
  #  {:ok, library: library}
  #end
end
