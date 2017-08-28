defmodule Recur.WeeklyTest do
  use ExUnit.Case
  #doctest Recur

  alias Recur

  @date ~D[2017-12-28]
  @valid_rrule %{start_date: @date, frequency: :weekly}

  test "for count 1 should return only one event" do
    events = Recur.unfold(@valid_rrule |> Map.put(:count, 1))
    assert [@date] == events |> Enum.take(999)
  end

  test "for until ~D[2018-01-11] it should return 3 events" do
    until = ~D[2018-01-11]
    events = Recur.unfold(@valid_rrule |> Map.put(:until, until))
    assert 3 == Enum.count(events)
    assert [@date, ~D[2018-01-04], ~D[2018-01-11]] ==
      events |> Enum.take(999)
  end

  test "with no count, until and interval it should stream forever" do
    events = Recur.unfold(@valid_rrule)
    assert 1 == Enum.count(events |> Enum.take(1))
    assert 16 == Enum.count(events |> Enum.take(16))
    assert 96 == Enum.count(events |> Enum.take(96))
  end

  test "for count 5 it should return 5 events" do
    events = Recur.unfold(@valid_rrule |> Map.put(:count, 5))
    assert 5 == Enum.count(events)
  end

  test "for interval 5 it should return event every 5 weeks" do
    events = Recur.unfold(@valid_rrule |> Map.put(:interval, 5))
    assert 2 == Enum.count(events |> Enum.take(2))
    assert [@date, ~D[2018-02-01]] == events |> Enum.take(2)
  end
end
