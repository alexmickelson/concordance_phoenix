defmodule Concordance.DynamicSupervisor do
  use DynamicSupervisor
  # https://jkmrto.netlify.com/posts/dynamic-supervisor-in-elixir/
  alias Concordance.Memory
  alias Concordance.Location
  @name :concordance_dynamic_supervisor

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

  def start_child(%Concordance{} = concordance, sup_opts \\ [], child_opts \\ []) do
    spec = %{id: Memory, start: {Memory, :start_link, [concordance, child_opts]}}
    DynamicSupervisor.start_child(get_name(sup_opts), spec)
  end

  def add_or_update(word, %Location{} = location, sup_opts \\ [], child_opts \\ []) do
    case GenServer.whereis(Memory.get_name(word, child_opts)) do
      nil ->
        concordance = %Concordance{
          word: word,
          locations: [location]
        }
        start_child(concordance, sup_opts, child_opts)
      _pid ->
        Memory.add_location(word, location, child_opts)
    end
  end

  def get_children(opts \\ []) do
    DynamicSupervisor.which_children(get_name(opts))
    |> Enum.map(fn {_, pid, _, _} ->
      Memory.report(pid)
    end)
  end
end
