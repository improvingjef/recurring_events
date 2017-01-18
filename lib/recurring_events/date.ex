defmodule RecurringEvents.Date do

  def shift_date(%{year: year, month: month, day: day} = date, count, period) do
    {new_year, new_month, new_day} =
      shift_date({year, month, day}, count, period)
    %{date | year: new_year, month: new_month, day: new_day}
  end

  def shift_date({_year, _month, _day} = date, count, :days) do
    date
      |> :calendar.date_to_gregorian_days
      |> Kernel.+(count)
      |> :calendar.gregorian_days_to_date
  end

  def shift_date({year, month, day}, count, :months) do
    months = (year * 12) + (month - 1) + count

    new_year = div(months, 12)
    new_month = rem(months, 12) + 1

    last_day = :calendar.last_day_of_the_month(new_year, new_month)
    new_day = min(day, last_day)

    {new_year, new_month, new_day}
  end

  def shift_date({year, month, day}, count, :years) do
    {year + count, month, day}
  end

  def compare(%{year: y1, month: m1, day: d1},
              %{year: y2, month: m2, day: d2}) do
    compare({y1, m1, d1}, {y2, m2, d2})
  end

  def compare({y1, m1, d1}, {y2, m2, d2}) do
    cond do
      y1 == y2 and m1 == m2 and d1 == d2
        -> :eq
      y1 > y2 or (y1 == y2 and m1 > m2) or (y1 == y2 and m1 == m2 and d1 > d2)
        -> :gt
      true
        -> :lt
    end
  end
end