defmodule Utilities.Random.DiceTest do
  use ExUnit.Case, async: true
  doctest Utilities.Random.Dice

  test "roll(1, 10)" do
    defmodule A do
      import Utilities.Random.Dice, only: [dice_for: 1]

      dice_for(2)
    end

    assert A.d2(1)
  end

  for sides <- [2, 4, 6, 8, 10, 12, 20, 100] do
    test "100d#{sides}" do
      apply(Utilities.Random, :"d#{unquote(sides)}", [100])
      |> Enum.each(fn result -> assert 1..unquote(sides) |> Enum.member?(result) end)
    end

    test "oneD#{sides}" do
      assert 1..unquote(sides)
             |> Enum.member?(apply(Utilities.Random, :"oneD#{unquote(sides)}", []))
    end

    test "sumD#{sides}" do
      assert 1..(unquote(sides) * 100)
             |> Enum.member?(apply(Utilities.Random, :"sumD#{unquote(sides)}", [100]))
    end
  end
end
