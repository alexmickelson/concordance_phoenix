defmodule Gutenburg.BookWorker do
  @moduledoc """
  - starts with a book id
  - gets the book id from gutenburg
  - sends a call to start the parsing genserver
  """
  use GenServer
  alias Parsing.DynamicSupervisor, as: ParsingSup
  alias Gutenburg.Book
  alias Parsing.TextSection
  @parsing :parsing_application_supervisor
  @concordance :concordance_application_supervisor

  def start_link(book_id) do
    GenServer.start_link(__MODULE__, %Book{id: book_id})
  end

  def init(%Book{} = state) do
    {:ok, state, {:continue, nil}}
  end

  def handle_continue(nil, %Book{} = state) do
    case Book.get_book_from_gutenburg(state) do
      {:ok, state} ->
        Book.split_into_sections(state, 1000)
        |> Enum.each(fn %TextSection{} = section ->
          IO.puts "sending section #{section.word_offset}, #{section.book_title}"
          ParsingSup.start_child(section)
        end)
        {:noreply, state}
      :error ->
        {:noreply, state}
    end
  end
end
