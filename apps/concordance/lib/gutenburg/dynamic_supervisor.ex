defmodule Gutenburg.DynamicSupervisor do
  use DynamicSupervisor
  alias Gutenburg.BookWorker

  @name :gutenburg_dynamic_supervisor

  defp get_name(opts) do
    Keyword.get(opts, :name, @name)
  end

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, {}, name: get_name(opts))
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(book_number, opts \\ []) do
    spec = %{id: BookWorker, start: {BookWorker, :start_link, [book_number]}}
    DynamicSupervisor.start_child(get_name(opts), spec)
  end
end
