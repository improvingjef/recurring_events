defmodule Recur.Dates do

  @week_days %{monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7}

  def details(date, week_start) do
    week_start = week_start || :monday
    dow = day_of_week(date, week_start)

    date
    |> Map.put(:date, date)
    |> Map.put(:day_of_week, dow)
    |> Map.put(:day_of_week_name, day_of_week_name(dow, week_start))
    |> Map.put(:by_month_day, %{forward: date.day, reverse: date.day - 1 - Date.days_in_month(date)})
    |> Map.put(:by_year_day, %{forward: day_of_year(date), reverse: day_of_year(date) - 1 - day_of_year(%{date | month: 12, day: 31})})
    |> Map.put(:which_day_of_week, %{forward: dow, reverse: - 8 + dow})
    |> Map.put(:which_day_of_month, %{forward: which_day_of_month(date), reverse: reverse_which_day_of_month(date)})
    |> Map.put(:by_week_no, %{forward: week_of_year(date, week_start), reverse: week_of_year(date, week_start) - 1 - week_of_year(%{date | month: 12, day: 31}, week_start)})
    |> Map.to_list()
    |> Enum.filter(& elem(&1,0) != :__struct__)
    |> Enum.into(Map.new)
  end

  def day_of_week(date, week_start) do
    dow = Date.day_of_week(date)
    base_dow = @week_days[week_start]
    num = if dow < base_dow, do: 7 + dow - base_dow, else: dow - base_dow
    rem(num, 7) + 1
  end

  def day_of_week_name(day_number, week_start) do
    base = @week_days[week_start]

    default =
    @week_days
    |> Map.to_list
    |> Enum.sort_by(&elem(&1,1))
    |> Enum.map(&elem(&1,0))
    |> Enum.to_list()

    default
    |> Enum.drop(base - 1)
    |> Enum.concat(Enum.take(default, base-1))
    |> Enum.at(day_number - 1)
  end

  def day_of_year(date) do
    jan1 = %{date | month: 1, day: 1}
    case date.month do
      1 -> date.day
      _ ->
        1..(date.month-1)
        |> Enum.map(&(%{ date | month: &1, day: 1}))
        |> Enum.map(&(Date.days_in_month(&1)))
        |> Enum.concat([date.day])
        |> Enum.sum()
    end
  end

  def reverse_which_day_of_month(date) do
    ((Date.days_in_month(date) + 1 - date.day) / 7.0
    |> Float.ceil(0)
    |> round()) * -1
  end

  def which_day_of_month(date) do
    (date.day / 7.0) |> Float.ceil(0) |> round()
  end

  def week_of_year(date, week_start) do
    jan1 = %{date | month: 1, day: 1}
    jan1_dow = day_of_week(jan1, week_start)
    :calendar.iso_week_number()
    days =
      cond do
        jan1_dow < 5 -> (day_of_year(date) + 1)
        date.month == 1 and date.day <= (8 - jan1_dow) -> date.day + 1 + day_of_year(%{date | year: date.year - 1, month: 12, day: 31})
        true -> (day_of_year(date) + 1 - (8 - jan1_dow))
      end

    (days / 7.0 ) |> Float.ceil(0) |> round()
  end
end
