defmodule Recur.Filter do
  use Recur.Guards
  alias Recur.Dates

  def filter(date, %{frequency: :yearly} = rules)
    when is_map(rules) do

    rules
    |> replace_key(:by_day, :by_day_yearly)
    |> ensure_key(:by_month, rules.start_date.month, [:by_day_yearly, :by_year_day])
    |> ensure_key(:by_month_day, rules.start_date.day, [:by_day_yearly, :by_year_day])
    |> match(date)
  end

  def filter(date, %{frequency: :monthly} = rules)
    when is_map(rules) do

    rules
    |> ensure_key(:by_month_day, rules.start_date.day, [:by_day, :by_year_day])
    |> match(date)
  end

  def filter(date, %{frequency: :weekly} = rules)
    when is_map(rules) do

    rules
    |> ensure_key(:by_day, rules.start_date.day_of_week_name, [])
    |> match(date)
  end

  def filter(date, %{frequency: :daily} = rules)
    when is_map(rules) do
    match(rules, date)
  end

  def by(:by_month, _, value)
    when is_integer(value) and (value < 1 or value > 12),
    do: raise ArgumentError, message: "by_month expects a number between 1 and 12; got #{value}"

  def by(:by_day_yearly, _, value)
    when is_integer(value) and (value < -53 or value > 53 or value == 0),
      do: raise ArgumentError, message: "by_day_yearly expects a number between -53..1 or 1..53; got #{value}"

  def by(:by_month_day, date, value)
    when not is_list(value) and not is_integer(value) do
      IO.inspect({date, value})
      raise ArgumentError, message: "by_month_day expects a number; #{value}"
  end

  def by(:by_month_day, _, value)
    when is_integer(value) and not is_valid_month_day(value),
    do: raise ArgumentError, message: "by_month_day expects a number between 1 and 31; got " <> Integer.to_string(value)

  def by(:by_day, _, value)
    when is_atom(value) and value not in [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday],
    do: raise ArgumentError, message: "by_day expects a one of :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday; got #{value}"

  def by(filter, _, {_, which})
    when (filter in [:by_month_day, :by_year_day]) and which == 0,
    do: raise ArgumentError, "#{filter} 'which' parameter cannot be zero."

  def by(by_filter, date, values)
    when is_valid_filter(by_filter) and is_list(values) do

    Enum.any?(values, &by(by_filter, date, &1))
  end

  def by(:by_month, date, value)
    when is_integer(value) do

    date.month == value
  end

  def by(by_filter, date, value)
    when is_atom(value) and by_filter in [:by_day, :by_day_yearly, :by_month_day],
      do: by(by_filter, date, {value, 0})

  def by(:by_day, date, {value, which})
    when is_atom(value) do

    value == date.day_of_week_name
    and (which == 0 or which(date.which_day_of_month, which))
  end

  def by(:by_day_yearly, date, {value, which})
    when is_atom(value) do

    value == date.day_of_week_name
    and (which == 0 or which(date.by_week_no, which))
  end

  def by(:by_week_no, date, value)
    when is_integer(value)
  do
    which(date.which_day_of_week, value)
  end

  def by(by_filter, date, value)
    when by_filter in [:by_month_day, :by_year_day, :by_week_no] and is_integer(value) do

    which(date[by_filter], value)
  end

  def by(:by_year_day, date, value)
    when is_integer(value) do

    which(date.day_of_year, value)
  end

  defp replace_key(map, key, replacement_key) do
    if Map.has_key?(map, key) do
      map
      |> Map.put(replacement_key, Map.get(map, key))
      |> Map.drop([key])
    else
      map
    end
  end

  defp ensure_key(map, key, value_if_missing, keys_are_present) do
    if Map.has_key?(map, key) or Enum.any?(keys_are_present || [], &Map.has_key?(map, &1)) do
      map
    else
       Map.put(map, key, value_if_missing)
    end
  end

  defp match(rules, date) do
    rules_to_exclude = [:frequency, :interval, :count, :until, :start_date, :week_start]

    detail = Dates.details(date, rules[:week_start])

    matches =
      rules
      |> Map.to_list()
      |> Enum.filter(fn rule -> Enum.any?(rules_to_exclude, & &1 == elem(rule,0)) == false end)
      |> Enum.map(&(by(elem(&1,0), detail, elem(&1,1))))

      Date.compare(rules.start_date, date) == :eq
      || Enum.empty?(matches)
      || Enum.all?(matches, &(&1))
  end

  defp which(day_of, value) do
    cond do
      value > 0 -> day_of.forward == value
      value < 0 -> day_of.reverse == value
    end
  end
end
