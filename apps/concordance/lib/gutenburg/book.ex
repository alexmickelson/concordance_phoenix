defmodule Gutenburg.Book do
  defstruct id: nil,
            title: nil,
            text: nil
  alias Gutenburg.Book
  alias Parsing.TextSection
  def get_title(text) do
    first_line_pattern = ~r/^(.*)\r\n/
    [_, title | _] = Regex.run(first_line_pattern, text)
    title
  end

  def get_book_from_gutenburg(%Book{} = book) do
    gutenburg_url = "http://dev.gutenberg.org/files/#{book.id}/#{book.id}.txt"
    headers = []
    case HTTPoison.get(gutenburg_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect book.id, label: "got book from gutenburg"
        {:ok, %Book{book | text: body, title: get_title(body)}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.inspect book.id, label: "Book not found"
        :error
      error ->
        IO.inspect error, label: "Error getting book from gutenburg"
        :error
    end
  end

  def split_into_sections(%Book{} = book, section_length) do
    {_, sections} =
      book.text
      |> String.splitter([" ", "\r\n"])
      |> Stream.chunk_every(section_length)
      |> Enum.map(fn list -> List.flatten(list) |> Enum.join(" ") end)
      |> Enum.reduce({0, []}, fn text, {offset, sections} ->
        new_section = %TextSection{
          book_title: book.title,
          word_offset: offset,
          text: text
        }
        {offset + section_length, [new_section | sections]}
      end)
    sections
  end
end
