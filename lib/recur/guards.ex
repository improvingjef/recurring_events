defmodule Recur.Guards do
  @moduledoc """
  Provides guard macros for internal use
  """

  defmacro __using__(_) do
    quote do
      import Recur.Guards
    end
  end

  defmacro is_valid_month_day(day) do
    quote do
      unquote(day) > 0 and unquote(day) < 32
      or
      unquote(day) > -32 and unquote(day) < 0
    end
  end

  defmacro is_valid_filter(filter) do
    quote do
      unquote(filter) == :by_year_day     or
      unquote(filter) == :by_day_yearly   or
      unquote(filter) == :by_month_day    or
      unquote(filter) == :by_week_no      or
      unquote(filter) == :by_day          or
      unquote(filter) == :by_month        or
      unquote(filter) == :by_hour         or
      unquote(filter) == :by_minute       or
      unquote(filter) == :by_second       or
      unquote(filter) == :by_set_position
    end
  end

  defmacro is_valid_frequency(freq) do
    quote do
      unquote(freq) == :yearly    or
      unquote(freq) == :monthly   or
      unquote(freq) == :weekly    or
      unquote(freq) == :daily     or
      unquote(freq) == :hourly    or
      unquote(freq) == :minutely  or
      unquote(freq) == :secondly
    end
  end
end
