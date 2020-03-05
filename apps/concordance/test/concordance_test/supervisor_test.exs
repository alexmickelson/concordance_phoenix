defmodule ConcordanceTest.SupervisorTest do
  use ExUnit.Case
  alias Concordance.DynamicSupervisor, as: ConcordanceSup
  alias Concordance.Location
  alias Concordance.Memory

  test "can start a child from the dynamic supervisor" do
    opts = [name: :conc_sup_test_0]
    child_opts = [name: :conc_child_0]
    {:ok, _} = ConcordanceSup.start_link(opts)

    word = "word"
    concordance = %Concordance{word: word, locations: [%Location{book: "elixir in action", word_number: 2}]}

    {:ok, _} = ConcordanceSup.start_child(concordance, opts, child_opts)
    state = Memory.get_concordance(word, child_opts)
    assert state.word == word
  end

  test "add or update adds if no child exists" do
    opts = [name: :conc_sup_test_1]
    child_opts = [name: :conc_child_1]

    {:ok, _} = ConcordanceSup.start_link(opts)

    word = "apple"
    location = %Location{
      book: "oathbreaker",
      word_number: 3
    }

    ConcordanceSup.add_or_update(word, location, opts, child_opts)

    actual = Memory.get_concordance(word, child_opts)
    expected = %Concordance{
      word: word,
      locations: [location]
    }
    assert expected == actual
  end

  test "appends location to memory if exists" do
    opts = [name: :conc_sup_test_0]
    child_opts = [name: :conc_child_0]

    {:ok, _} = ConcordanceSup.start_link(opts)

    word = "apple"
    location = %Location{
      book: "oathbreaker",
      word_number: 3
    }
    location2 = %Location{
      book: "oathbreaker",
      word_number: 300
    }

    ConcordanceSup.add_or_update(word, location, opts, child_opts)
    ConcordanceSup.add_or_update(word, location2, opts, child_opts)
    actual = Memory.get_concordance(word, child_opts)
    expected = %Concordance{
      word: word,
      locations: [location, location2]
    }
    assert expected.locations |> Enum.sort == actual.locations |> Enum.sort
  end
end
