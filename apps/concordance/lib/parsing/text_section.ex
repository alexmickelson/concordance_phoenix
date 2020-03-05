defmodule Parsing.TextSection do
  defstruct book_title: "",
            word_offset: 0,
            text: "",
            concordance_memory_opts: [],
            concordance_sup_opts: []
  alias Parsing.TextSection
  alias Concordance.Location
  alias Concordance.DynamicSupervisor, as: ConcordanceSup

  def process_text_section(%TextSection{} = state) do
    String.split(state.text, [" ", ",", ".", ";", "?", "!", ":", "_", "(", ")", "&", "$", "'", "#", "\\", "--", "/", "*", "\""])
    |> Enum.reduce(state.word_offset, fn word, index ->
      location = %Location{
        book: state.book_title,
        word_number: index
      }
      # IO.inspect location, label: "Sending to concordance_sup"
      if String.printable?(word) do
        word
        |> String.downcase
        |> ConcordanceSup.add_or_update(location, state.concordance_sup_opts, state.concordance_memory_opts)
        index + 1
      end
    end)
  end
end
