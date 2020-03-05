defmodule Concordance do
  defstruct word: "",
            locations: []
  alias Concordance.Location

  def report(%Concordance{} = concordance) do
    locations =
      Enum.take(concordance.locations, 5)
      # |> Enum.map(fn %Location{} = location ->
      #   "word_number: #{location.word_number}, book: #{location.book}"
      # end)
    {concordance.word, locations}
  end
end
