defmodule RecurTest do
  use ExUnit.Case
  #doctest Recur

  alias Recur, as: RR

  @date ~N[2017-01-01 10:00:00]
  @valid_rrule %{start_date: @date, frequency: :yearly}

  test "freq is required" do
    assert_raise ArgumentError, "Recur rules must specify a valid frequency parameter.", fn ->
      RR.unfold(%{start_date: @date})
    end
  end

  test "will rise error if frequency is invalid" do
    assert_raise ArgumentError, "Recur rules must specify a valid frequency parameter.", fn ->
      RR.unfold(%{start_date: @date, frequency: :whatever})
    end
  end

  test "can have eathier until or count" do
    assert_raise ArgumentError, "Recur rules may not contain both count and until.", fn ->
      RR.unfold(Map.merge(@valid_rrule, %{count: 1, until: 2}))
    end
  end

  test "can handle yearly frequency" do
    events  =
      RR.unfold(%{start_date: @date, frequency: :yearly})
      |> Enum.take(3)
    assert 3 = Enum.count(events)
  end

  test "can handle monthly frequency" do
    events =
      RR.unfold(%{start_date: @date, frequency: :monthly})
      |> Enum.take(36)
    assert 36 = Enum.count(events)
  end

  test "can handle daily frequency" do
    events =
      RR.unfold(%{start_date: @date, frequency: :daily})
      |> Enum.take(90)
    assert 90 = Enum.count(events)
  end

  test "can handle weekly frequency" do
    events =
      RR.unfold(%{start_date: @date, frequency: :weekly})
      |> Enum.take(13)
    assert 13 = Enum.count(events)
  end

  test "can return list instead of stream" do
    stream = RR.unfold(%{start_date: @date, frequency: :weekly})
    list = RR.take(%{start_date: @date, frequency: :weekly}, 29)
    assert is_list(list)
    assert list == Enum.take(stream, 29)
  end
end
