defmodule Recur do
  @moduledoc """
  Handles `:daily` frequency rule
  """
  use Recur.Guards
  alias Recur.Filter

  @doc """
  Returns daily stream of dates with respect to `:interval`, `:count` and
  `:until` rules. Time in date provided as `:until` is ignored.

  # Example

      iex> Recur.unfold(%{start_date: ~N[2017-01-22 10:11:11],
      ...> frequency: :daily, until: ~N[2017-01-23 05:00:00]})
      ...> |> Enum.take(2)
      [~N[2017-01-22 10:11:11], ~N[2017-01-23 10:11:11]]

  """
  def unfold(%{count: _, until: _}) do
    raise ArgumentError, message: "Recur rules may not contain both count and until."
  end

  def unfold(%{start_date: start_date, frequency: freq} = rules)
    when is_valid_frequency(freq) do

    rules = %{rules | start_date: Dates.details(start_date, rules[:week_start])}
    start_date
    |> Stream.iterate(&Date.add(&1, 1))
    |> Stream.filter(&interval(&1, rules))
    |> Stream.filter(&Filter.filter(&1, rules))
    |> terminate(rules)
  end

  def unfold(_) do
    raise ArgumentError, message: "Recur rules must specify a valid frequency parameter."
  end

  def take(rules, count) do
    rules
    |> unfold()
    |> Enum.take(count)
  end

  def interval(date, %{start_date: start_date, frequency: frequency, interval: interval} = rules)
  when is_integer(interval) do
    week_start = rules[:week_start] || :monday
    0 == rem(diff(frequency, start_date, date, week_start), interval)
  end

  def interval(_, _) do
    true
  end

  def diff(:yearly, start_date, date, _week_start) do
    date.year - start_date.year
  end

  def diff(:monthly, start_date, date, _week_start) do
    date = %{date | day: 1}

    %{start_date | day: 1}
    |> Stream.iterate(fn d -> Date.add(d, Date.days_in_month(d)) end)
    |> Stream.take_while(& Date.compare(&1, date) == :lt)
    |> Enum.to_list()
    |> Enum.count()
  end

  def diff(:weekly, start_date, date, week_start) do
    # g1 = :calendar.date_to_gregorian_days(date)
    # g2 = :calendar.date_to_gregorian_days(start_date)
    # div(g1 - g2 + 1, 7)
    :daily
    |> diff(start_date, date, week_start)
    |> div(7)
  end

  def diff(:daily, start_date, date, _week_start) do
    :calendar.date_to_gregorian_days(date |> Date.to_erl()) -
    :calendar.date_to_gregorian_days(start_date |> Date.to_erl())
  end

  def terminate(dates, rules) do
    case rules do
      %{count: count} -> Stream.take(dates, count)
      %{until: until} -> Stream.take_while(dates, &is_not_past(&1, until))
      _ -> dates
    end
  end

  def is_not_past(date, end_date) do
    Enum.any?([:lt, :eq], &(&1 == Elixir.Date.compare(date, end_date)))
  end
end
