defmodule RecurTest.ByMonthTest do
  use ExUnit.Case
  ##doctest Recur

  alias Recur

  @date ~D[2017-01-20]

  test "can filter by month when frequency: :daily" do
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :daily, by_month: Map.get(@date, :month)})
      |> Enum.take(1)
    assert [] ==
      Recur.unfold(%{start_date: @date, frequency: :daily, by_month: [2,5,9]})
      |> Enum.take(1)
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :daily, by_month: [1,2,3]})
      |> Enum.take(1)
  end

  test "can filter by month when frequency: :weekly" do
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :weekly, by_month: 1})
      |> Enum.take(1)
    assert [] ==
      Recur.unfold(%{start_date: @date, frequency: :weekly, by_month: [2,5,9]})
      |> Enum.take(1)
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :weekly, by_month: [1,2,3]})
      |> Enum.take(1)
  end

  test "can filter by month when frequency: :monthly" do
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :monthly, by_month: 1})
      |> Enum.take(1)
    assert [%{@date | month: 2}, %{@date | month: 5}, %{@date | month: 9}] ==
      Recur.unfold(%{start_date: @date, frequency: :monthly, by_month: [2,5,9]})
      |> Enum.take(3)
    assert [@date] ==
      Recur.unfold(%{start_date: @date, frequency: :monthly, by_month: [1,2,3]})
      |> Enum.take(1)
  end

  test "can inflate months when frequency: :yearly" do
    assert [~D[2017-02-20]] ==
      Recur.unfold(%{start_date: @date, frequency: :yearly, by_month: 2})
      |> Enum.take(1)
    assert [~D[2017-02-20], ~D[2017-05-20]] ==
      Recur.unfold(%{start_date: @date, frequency: :yearly, by_month: [2,5]})
      |> Enum.take(2)
  end
end
