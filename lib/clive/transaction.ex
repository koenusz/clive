defmodule Clive.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Clive.Repo

  alias Clive.Transaction.SendTest

  @doc """
  Returns the list of send_tests.

  ## Examples

      iex> list_send_tests()
      [%SendTest{}, ...]

  """
  def list_send_tests do
    Repo.all(SendTest)
  end

  @doc """
  Gets a single send_test.

  Raises `Ecto.NoResultsError` if the Send test does not exist.

  ## Examples

      iex> get_send_test!(123)
      %SendTest{}

      iex> get_send_test!(456)
      ** (Ecto.NoResultsError)

  """
  def get_send_test!(id), do: Repo.get!(SendTest, id)

  @doc """
  Creates a send_test.

  ## Examples

      iex> create_send_test(%{field: value})
      {:ok, %SendTest{}}

      iex> create_send_test(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_send_test(attrs \\ %{}) do
    %SendTest{}
    |> SendTest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a send_test.

  ## Examples

      iex> update_send_test(send_test, %{field: new_value})
      {:ok, %SendTest{}}

      iex> update_send_test(send_test, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_send_test(%SendTest{} = send_test, attrs) do
    send_test
    |> SendTest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a send_test.

  ## Examples

      iex> delete_send_test(send_test)
      {:ok, %SendTest{}}

      iex> delete_send_test(send_test)
      {:error, %Ecto.Changeset{}}

  """
  def delete_send_test(%SendTest{} = send_test) do
    Repo.delete(send_test)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking send_test changes.

  ## Examples

      iex> change_send_test(send_test)
      %Ecto.Changeset{data: %SendTest{}}

  """
  def change_send_test(%SendTest{} = send_test, attrs \\ %{}) do
    SendTest.changeset(send_test, attrs)
  end
end
