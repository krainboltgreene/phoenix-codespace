defmodule CoreTest do
  use ExUnit.Case, async: true
  doctest Core

  test "normative/1" do
    assert Utilities.String.normative(%{pronouns: %{normative: "he"}}) == "he"
  end

  test "accusative/1" do
    assert Utilities.String.accusative(%{pronouns: %{accusative: "him"}}) == "him"
  end

  test "genitive/1" do
    assert Utilities.String.genitive(%{pronouns: %{genitive: "his"}}) == "his"
  end

  test "reflexive/1" do
    assert Utilities.String.reflexive(%{pronouns: %{reflexive: "himself"}}) == "himself"
  end

  test "pronoun/2" do
    assert Utilities.String.pronoun(%{pronouns: %{normative: "he"}}, :normative) == "he"
    assert Utilities.String.pronoun(%{pronouns: %{accusative: "him"}}, :accusative) == "him"
    assert Utilities.String.pronoun(%{pronouns: %{genitive: "his"}}, :genitive) == "his"
    assert Utilities.String.pronoun(%{pronouns: %{reflexive: "himself"}}, :reflexive) == "himself"
    assert Utilities.String.pronoun(nil, :normative) == "it"
    assert Utilities.String.pronoun(nil, :accusative) == "it"
    assert Utilities.String.pronoun(nil, :genitive) == "its"
    assert Utilities.String.pronoun(nil, :reflexive) == "itself"
  end

  test "gendered_noun()" do
    assert Utilities.String.gendered_noun("God", "feminine") == "Godess"
    assert Utilities.String.gendered_noun("God", "masculine") == "God"
  end

  test "multiple(..., [{1, 10}, {2, 40}, {3, 50}])" do
    result = Utilities.Enum.multiple([{1, 10}, {2, 40}, {3, 50}], fn -> :example end)
    assert result |> Enum.all?(fn item -> item == :example end)
  end

  test "multiple(..., 5, 5)" do
    result = Utilities.Enum.multiple(5, 5, fn -> :example end)
    assert length(result) === 5
    assert result |> Enum.all?(fn item -> item == :example end)
  end

  test "multiple(..., 1, 5)" do
    result = Utilities.Enum.multiple(1, 5, fn -> :example end)
    assert 1..5 |> Enum.member?(length(result))
    assert result |> Enum.all?(fn item -> item == :example end)
  end

  test "multiple_unique(1, 5, ...)" do
    result = Utilities.Enum.multiple_unique(1, 5, fn -> Enum.random(1..5) end)
    assert 1..5 |> Enum.member?(length(result))
    assert result |> Enum.all?(fn item -> Enum.member?(1..5, item) end)
  end

  test "multiple_unique(5, 5, ...)" do
    result = Utilities.Enum.multiple_unique(5, 5, fn -> Enum.random(1..5) end)
    assert 1..5 |> Enum.member?(length(result))
    assert result |> Enum.sort() == [1, 2, 3, 4, 5]
  end
end
