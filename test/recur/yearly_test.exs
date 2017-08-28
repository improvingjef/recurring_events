defmodule Recur.YearlyTest do
  use ExUnit.Case
  #doctest Recur

  alias Recur

  @date ~D[2017-01-01]
  @valid_rrule %{start_date: @date, frequency: :yearly}

  test "for count 1 should return only one event" do
    events = Recur.unfold(@valid_rrule |> Map.put(:count, 1))
    assert [@date] == events |> Enum.take(999)
  end

  test "for until ~D[2018-11-01] it should return 2 events" do
    until = ~D[2018-11-01]
    events = Recur.unfold(@valid_rrule |> Map.put(:until, until))
    assert 2 == Enum.count(events)
    assert [@date, %{@date | year: 2018}] == events |> Enum.take(999)
  end

  test "with no count, until and interval it should stream forever" do
    events = Recur.unfold(@valid_rrule)
    assert 1 == events |> Enum.take(1) |> Enum.count()
    assert 16 == events |> Enum.take(16) |> Enum.count()
    assert 96 == events |> Enum.take(96) |> Enum.count()
  end

  test "for count 5 it should return 5 events" do
    events = Recur.unfold(@valid_rrule |> Map.put(:count, 5))
    assert 5 == Enum.count(events)
  end

  test "for interval 5 it should return event every 5th year" do
    events = Recur.unfold(@valid_rrule |> Map.put(:interval, 5))
    assert 2 == Enum.count(events |> Enum.take(2))
    assert [@date, %{@date | year: 2022}] == events |> Enum.take(2)
  end
end
