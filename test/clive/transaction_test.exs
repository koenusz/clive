defmodule Clive.TransactionTest do
  use Clive.DataCase

  alias Clive.Transaction

  describe "send_tests" do
    alias Clive.Transaction.SendTest

    import Clive.TransactionFixtures

    @invalid_attrs %{address: nil, amount: nil}

    test "list_send_tests/0 returns all send_tests" do
      send_test = send_test_fixture()
      assert Transaction.list_send_tests() == [send_test]
    end

    test "get_send_test!/1 returns the send_test with given id" do
      send_test = send_test_fixture()
      assert Transaction.get_send_test!(send_test.id) == send_test
    end

    test "create_send_test/1 with valid data creates a send_test" do
      valid_attrs = %{address: "some address", amount: 42}

      assert {:ok, %SendTest{} = send_test} = Transaction.create_send_test(valid_attrs)
      assert send_test.address == "some address"
      assert send_test.amount == 42
    end

    test "create_send_test/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_send_test(@invalid_attrs)
    end

    test "update_send_test/2 with valid data updates the send_test" do
      send_test = send_test_fixture()
      update_attrs = %{address: "some updated address", amount: 43}

      assert {:ok, %SendTest{} = send_test} = Transaction.update_send_test(send_test, update_attrs)
      assert send_test.address == "some updated address"
      assert send_test.amount == 43
    end

    test "update_send_test/2 with invalid data returns error changeset" do
      send_test = send_test_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_send_test(send_test, @invalid_attrs)
      assert send_test == Transaction.get_send_test!(send_test.id)
    end

    test "delete_send_test/1 deletes the send_test" do
      send_test = send_test_fixture()
      assert {:ok, %SendTest{}} = Transaction.delete_send_test(send_test)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_send_test!(send_test.id) end
    end

    test "change_send_test/1 returns a send_test changeset" do
      send_test = send_test_fixture()
      assert %Ecto.Changeset{} = Transaction.change_send_test(send_test)
    end
  end
end
