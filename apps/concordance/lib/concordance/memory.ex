defmodule Concordance.Memory do
  @moduledoc """
  - recieves a word and a location on startup
  - can add more locations to a word on request
  - can return a bounded list of locations
  """
  use GenServer
  alias Concordance.Location
  @name :concordance_memory_process

  def get_name(word, opts) when is_list(opts) do
    name = Keyword.get(opts, :name, @name)
    :"#{word}_#{name}"
  end

  def start_link(%Concordance{} = state, opts \\ []) do
    name = get_name(state.word, opts)
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def get_concordance(word, opts \\ []) do
    GenServer.call(get_name(word, opts), :get_concordance)
  end

  def add_location(word, location, opts \\ []) do
    GenServer.cast(get_name(word, opts), {:add_location, location})
  end

  def report(pid) do
    GenServer.call(pid, :report)
  end

  @impl true
  def init(%Concordance{} = state) do
    # IO.inspect state.word, label: "Started concordance"
    {:ok, state}
  end

  @impl true
  def handle_call(:get_concordance, _from, %Concordance{} = state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:report, _, %Concordance{} = state) do
    {:reply, Concordance.report(state), state}
  end

  @impl true
  def handle_cast({:add_location, %Location{} = location}, %Concordance{} = state) do
    state = %Concordance{state | locations: [location | state.locations]}
    # IO.inspect location, label: "Added location to #{state.word}"
    {:noreply, state}
  end
end
