defmodule Recur.RuleInteractionTests do
  use ExUnit.Case
  #doctest Recur

  alias Recur, as: RR

  @jan1 ~D[2017-01-01]

  test "if yearly and by_month is specified, stream should contain month instances" do

    assert
    [~D[2017-06-01], ~D[2017-02-01]] ==
    RR.unfold(%{start_date: @jan1, frequency: yearly, by_month: [1,2], count: 2})
    |> Enum.take(3)
  end
end
