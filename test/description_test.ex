defmodule Recur.IcalRruleTest do
  use ExUnit.Case, async: true
  alias Recur.Description

  test "should describe yearly" do
    assert "Every year" == Description.describe(%{frequency: :yearly})
  end

  test "should describe monthly" do
    assert "Every month" == Description.describe(%{frequency: :monthly})
  end

  test "should describe weekly" do
    assert "Every week" == Description.describe(%{frequency: :weekly})
  end

  test "should describe daily" do
    assert "Every day" == Description.describe(%{frequency: :daily})
  end

  test "should describe yearly with interval 2" do
    assert "Every other year" == Description.describe(%{frequency: :yearly, interval: 2})
  end

  test "should describe yearly with interval 3" do
    assert "Every 3rd year" == Description.describe(%{frequency: :yearly, interval: 3})
  end

  test "should handle by_month with one value with yearly" do
    assert "Every year in June" == Description.describe(%{frequency: :yearly, by_month: 6})
  end

  test "should handle by_month with yearly" do
    assert "Every year in June and July" == Description.describe(%{frequency: :yearly, by_month: [6,7]})
  end

  test "should use commas for more than 2 by_month values with yearly" do
    assert "Every year in June, July, and August" == Description.describe(%{frequency: :yearly, by_month: [6,7,8]})
  end


  test "should handle by_month_day with one value with yearly" do
    assert "Every year on the 11th day in June" == Description.describe(%{frequency: :yearly, by_month: 6, by_month_day: 11})
  end

  test "should handle by_month_day with two values with yearly" do
    assert "Every year on the 21st and 22nd days in June and July" == Description.describe(%{frequency: :yearly, by_month: [6,7], by_month_day: [21,22]})
  end

  test "should use commas for more than 2 by_month_day values with yearly" do
    assert "Every year on the 3rd, 4th, and 11th days in June, July, and August" == Description.describe(%{frequency: :yearly, by_month: [6,7,8], by_month_day: [3,4,11]})
  end




  test "get month by number" do
    assert "January" == Description.by(:by_month, 1)
    assert "February" == Description.by(:by_month, 2)
    assert "March" == Description.by(:by_month, 3)
    assert "April" == Description.by(:by_month, 4)
    assert "May" == Description.by(:by_month, 5)
    assert "June" == Description.by(:by_month, 6)
    assert "July" == Description.by(:by_month, 7)
    assert "August" == Description.by(:by_month, 8)
    assert "September" == Description.by(:by_month, 9)
    assert "October" == Description.by(:by_month, 10)
    assert "November" == Description.by(:by_month, 11)
    assert "December" == Description.by(:by_month, 12)
  end

  test "ordinal indicators" do
    assert "st" == Description.ordinal_indicator(1)
    assert "nd" == Description.ordinal_indicator(2)
    assert "rd" == Description.ordinal_indicator(3)

    assert "th" == Description.ordinal_indicator(4)
    assert "th" == Description.ordinal_indicator(5)
    assert "th" == Description.ordinal_indicator(6)
    assert "th" == Description.ordinal_indicator(7)
    assert "th" == Description.ordinal_indicator(8)
    assert "th" == Description.ordinal_indicator(9)
    assert "th" == Description.ordinal_indicator(10)

    assert "th" == Description.ordinal_indicator(11)

    assert "st" == Description.ordinal_indicator(31)
    assert "nd" == Description.ordinal_indicator(32)
    assert "rd" == Description.ordinal_indicator(33)
    assert "th" == Description.ordinal_indicator(34)
    assert "th" == Description.ordinal_indicator(35)
    assert "th" == Description.ordinal_indicator(36)
    assert "th" == Description.ordinal_indicator(37)
    assert "th" == Description.ordinal_indicator(38)
    assert "th" == Description.ordinal_indicator(39)
  end

end
