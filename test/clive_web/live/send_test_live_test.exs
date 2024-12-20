defmodule CliveWeb.SendTestLiveTest do
  use CliveWeb.ConnCase

  import Phoenix.LiveViewTest
  import Clive.TransactionFixtures

  @create_attrs %{address: "some address", amount: 42}
  @update_attrs %{address: "some updated address", amount: 43}
  @invalid_attrs %{address: nil, amount: nil}

  defp create_send_test(_) do
    send_test = send_test_fixture()
    %{send_test: send_test}
  end

  describe "Index" do
    setup [:create_send_test]

    test "lists all send_tests", %{conn: conn, send_test: send_test} do
      {:ok, _index_live, html} = live(conn, ~p"/send_tests")

      assert html =~ "Listing Send tests"
      assert html =~ send_test.address
    end

    test "saves new send_test", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/send_tests")

      assert index_live |> element("a", "New Send test") |> render_click() =~
               "New Send test"

      assert_patch(index_live, ~p"/send_tests/new")

      assert index_live
             |> form("#send_test-form", send_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#send_test-form", send_test: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/send_tests")

      html = render(index_live)
      assert html =~ "Send test created successfully"
      assert html =~ "some address"
    end

    test "updates send_test in listing", %{conn: conn, send_test: send_test} do
      {:ok, index_live, _html} = live(conn, ~p"/send_tests")

      assert index_live |> element("#send_tests-#{send_test.id} a", "Edit") |> render_click() =~
               "Edit Send test"

      assert_patch(index_live, ~p"/send_tests/#{send_test}/edit")

      assert index_live
             |> form("#send_test-form", send_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#send_test-form", send_test: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/send_tests")

      html = render(index_live)
      assert html =~ "Send test updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes send_test in listing", %{conn: conn, send_test: send_test} do
      {:ok, index_live, _html} = live(conn, ~p"/send_tests")

      assert index_live |> element("#send_tests-#{send_test.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#send_tests-#{send_test.id}")
    end
  end

  describe "Show" do
    setup [:create_send_test]

    test "displays send_test", %{conn: conn, send_test: send_test} do
      {:ok, _show_live, html} = live(conn, ~p"/send_tests/#{send_test}")

      assert html =~ "Show Send test"
      assert html =~ send_test.address
    end

    test "updates send_test within modal", %{conn: conn, send_test: send_test} do
      {:ok, show_live, _html} = live(conn, ~p"/send_tests/#{send_test}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Send test"

      assert_patch(show_live, ~p"/send_tests/#{send_test}/show/edit")

      assert show_live
             |> form("#send_test-form", send_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#send_test-form", send_test: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/send_tests/#{send_test}")

      html = render(show_live)
      assert html =~ "Send test updated successfully"
      assert html =~ "some updated address"
    end
  end
end
