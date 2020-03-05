defmodule Parsing.DynamicSupervisor do
  use DynamicSupervisor
  alias Parsing.TextSection
  alias Parsing.TextWorker
  @name :parsing_dynamic_supervisor

  defp get_name(opts) do
    Keyword.get(opts, :name, @name)
  end

  def start_link(opts \\ []) do
    name = get_name(opts)
    DynamicSupervisor.start_link(__MODULE__, {}, name: name)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(%TextSection{} = state, opts \\ []) do
    spec = %{id: TextWorker, start: {TextWorker, :start_link, [state]}}
    IO.puts "Starting child #{state.book_title} #{state.word_offset}"
    name = get_name(opts)
    DynamicSupervisor.start_child(name, spec)
  end
end
