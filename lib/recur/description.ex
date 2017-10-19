defmodule Recur.Description do
  @moduledoc """
    Recur.Description attempts to construct a reasonable
    sentence description of the provided set of rules.

    +-------+------+-------+------+
    |DAILY  |WEEKLY|MONTHLY|YEARLY|
    +-------+------+-------+------+
    |Limit  |Limit |Limit  |Expand| ByMonth
    +-------+------+-------+------+
    |N/A    |N/A   |N/A    |Expand| ByWeekNo
    +-------+------+-------+------+
    |N/A    |N/A   |N/A    |Expand| ByYearDay
    +-------+------+-------+------+
    |Limit  |N/A   |Expand |Expand| ByMonthDay
    +-------+------+-------+------+
    |Limit  |Expand|Note 1 |Note 2| ByDay
    +-------+------+-------+------+

    Note 1:
      Limit if BYMONTHDAY is present; otherwise, special expand
      for MONTHLY.

    Note 2:
      Limit if BYYEARDAY or BYMONTHDAY is present; otherwise,
      special expand for WEEKLY if BYWEEKNO present; otherwise,
      special expand for MONTHLY if BYMONTH present; otherwise,
      special expand for YEARLY.
  """
  @months ~w(January February March April May June July August September October November December)
  @frequency_names [yearly: "year", monthly: "month", weekly: "week", daily: "day"]

  def describe(rules) do
    ["Every"]
    |> interval(rules)
    |> frequency(rules)
    |> by(:by_month_day, rules)
    |> by(:by_month, rules)
    |> Enum.filter(& not is_nil(&1))
    |> Enum.join(" ")
    |> String.trim()
    |> IO.inspect()
  end

  def by(message, selector, params) do
    values = Map.get(params, selector)
    message ++
    case values do
      nil -> []
      x when is_list(x) ->
        [plural(selector, by(selector, values))]
      x when is_integer(x) ->
        [singular(selector, by(selector, values))]
      _ -> []
    end
  end

  def plural(:by_month_day, value), do: "on the #{value} days"
  def plural(:by_month, value), do: "in #{value}"

  def singular(:by_month_day, value), do: "on the #{value} day"
  def singular(:by_month, value), do: "in #{value}"

  def by(_, nil), do: nil
  def by(selector, values)
    when is_atom(selector) and is_list(values) do
    values
    |> Enum.map(&by(selector, &1))
    |> join_words("")
  end

  def by(:by_month_day, number)
    when is_integer(number) and number > 0 and number < 32 do
    interval(number)
  end

  def by(:by_month, number)
    when is_integer(number) and number > 0 and number < 13 do
    Enum.at(@months, number - 1)
  end

  def join_words([last], message) do
    message <> ", and " <> last
  end

  def join_words([first, last], "") do
    first <> " and " <> last
  end

  def join_words([head | rest], "") do
    join_words(rest, head)
  end

  def join_words([head | rest], message) do
    join_words(rest, message <> ", " <> head)
  end

  def frequency(message, %{frequency: freq}) do
    message ++ [@frequency_names[freq]]
  end

  def interval(message, %{interval: interval}) do
    message ++ [interval(interval)]
  end

  def interval(message, _) do
    message
  end

  def interval(1), do: nil
  def interval(2), do: "other"
  def interval(number)
    when is_integer(number) do
    Integer.to_string(number) <> ordinal_indicator(number)
  end

  def ordinal_indicator(number)
    when is_integer(number) do
    cond do
      rem(number - 2, 10) == 0 -> "nd"
      rem(number - 3, 10) == 0 -> "rd"
      number == 11 -> "th"
      rem(number - 1, 10) == 0 -> "st"
      true -> "th"
    end
  end
end
