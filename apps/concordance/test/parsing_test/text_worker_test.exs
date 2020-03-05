defmodule ParsingText.TextWorkerTest do
  use ExUnit.Case
  alias Parsing.TextSection
  alias Parsing.TextWorker
  alias Concordance.DynamicSupervisor, as: ConcordanceSup
  alias Concordance.Memory
  alias Concordance.Location

  test "text worker recieves text and starts concordance genservers" do
    conc_sup_opts = [name: :text_worker_test_0]
    conc_child_opts = [name: :conc_child_0]
    ConcordanceSup.start_link(conc_sup_opts)

    text_section = %TextSection{
      book_title: "Oathbringer",
      word_offset: 100,
      text: "the dog ran away",
      concordance_memory_opts: conc_child_opts,
      concordance_sup_opts: conc_sup_opts
    }
    TextWorker.start_link(text_section)
    Process.sleep(20)
    actual = Memory.get_concordance("the", conc_child_opts)
    expected = %Concordance{
      word: "the",
      locations: [%Location{book: text_section.book_title, word_number: 100}]
    }
    assert match?(expected, actual)
  end

  test "recurring words have 2 locations recorded" do
    conc_sup_opts = [name: :text_worker_test_1]
    conc_child_opts = [name: :conc_child_1]
    ConcordanceSup.start_link(conc_sup_opts)

    text_section = %TextSection{
      book_title: "Oathbringer",
      word_offset: 100,
      text: "the dog ran away the",
      concordance_memory_opts: conc_child_opts,
      concordance_sup_opts: conc_sup_opts
    }

    TextWorker.start_link(text_section)
    Process.sleep(20)
    actual = Memory.get_concordance("the", conc_child_opts)
    expected = %Concordance{
      word: "the",
      locations: [
        %Location{book: text_section.book_title, word_number: 100},
        %Location{book: text_section.book_title, word_number: 104}
      ]
    }
    assert actual.word == expected.word
    assert Enum.sort(actual.locations) == Enum.sort(expected.locations)
  end
end
