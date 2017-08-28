defmodule Recur.ByDayTest do
  use ExUnit.Case
  ##doctest Recur

  alias Recur

  @wednesday ~D[2017-01-25]
  @monday ~D[2017-01-23]
  @expected [~D[2017-01-04], ~D[2017-01-11], ~D[2017-01-18], ~D[2017-01-25]]


  test "can be filetered by day of the week when frequency: :daily" do
    assert [@monday] ==
      Recur.unfold(%{start_date: @monday, frequency: :daily, by_day: :monday})
      |> Enum.take(1)
  end

  test "can be inflate by week when frequency: :weekly" do
    assert [@monday, @wednesday] ==
      Recur.unfold(%{start_date: @monday, frequency: :weekly, by_day: [:monday, :wednesday]})
      |> Enum.take(2)
  end

  test "will not change if filtered by provided day with frequency: weekly" do
    assert [@wednesday] ==
      Recur.unfold(%{start_date: @wednesday, frequency: :weekly, by_day: :wednesday})
      |> Enum.take(1)
  end

  test "can be inflate by month when frequency: :monthly" do
    assert [~D[2017-01-04], ~D[2017-01-11], ~D[2017-01-18], @wednesday] ==
      Recur.unfold(%{start_date: @wednesday, frequency: :monthly, by_day: :wednesday})
      |> Enum.take(4)
  end

  test "can be inflate by year when frequency: yearly" do
    assert [
      ~D[2017-01-06], ~D[2017-01-13], ~D[2017-01-20], ~D[2017-01-27],
      ~D[2017-02-03], ~D[2017-02-10], ~D[2017-02-17], ~D[2017-02-24],
      ~D[2017-03-03], ~D[2017-03-10], ~D[2017-03-17], ~D[2017-03-24],
      ~D[2017-03-31],
    ] ==
      Recur.unfold(%{start_date: @wednesday, frequency: :yearly, by_day: :friday})
      |> Enum.take(13)
  end

  @tag :pending
  test "can be inflate by month when by_month: is empty" do
    assert @expected ==
      Recur.unfold(%{start_date: @wednesday, frequency: :daily, by_day: :wednesday, by_month: []})
      |> Enum.take(4)
  end


  test "can be inflate by month when by_month: is a single month" do
    assert @expected ==
      Recur.unfold(%{start_date: @wednesday, frequency: :weekly, by_day: :wednesday, by_month: 2})
      |> Enum.take(4)
  end

  # test "can be inflate by month when by_month: is nil" do
  #   assert @expected ==
  #     Recur.unfold(%{start_date: @wednesday, frequency: :yearly, by_day: :wednesday, by_month: nil})
  #     |> Enum.take(999)
  # end
end
