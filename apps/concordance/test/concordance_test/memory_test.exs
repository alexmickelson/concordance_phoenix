defmodule ConcordanceTest.MemoryTest do
  use ExUnit.Case
  alias Concordance.Location
  alias Concordance.Memory

  test "a concordance can be started with a word" do
    opts = [name: :memory_test_1]
    starting_word = "distributed"
    location = %Location{book: "Elixir in Action", word_number: 100}
    concordance = %Concordance{word: starting_word, locations: [location]}

    {:ok, _pid} = Memory.start_link(concordance, opts)

    %Concordance{word: actual_word, locations: locations} = Memory.get_concordance(starting_word, opts)

    assert starting_word == actual_word
    assert [location] == locations
  end

  test "a location can be added to a concordance" do
    opts = [name: :memory_test_2]

    starting_word = "distributed"
    location = %Location{book: "Elixir in Action", word_number: 100}
    concordance = %Concordance{word: starting_word, locations: [location]}

    {:ok, _pid} = Memory.start_link(concordance, opts)
    new_location = %Location{book: "Elixir in Action", word_number: 105}
    Memory.add_location(starting_word, new_location, opts)
    #might need a sleep here
    # Process.sleep(20)
    %Concordance{word: actual_word, locations: locations} = Memory.get_concordance(starting_word, opts)

    expected_locations = [location, new_location]

    assert expected_locations |> Enum.sort == locations |> Enum.sort()
  end
end
