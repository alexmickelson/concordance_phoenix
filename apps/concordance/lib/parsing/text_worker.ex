defmodule Parsing.TextWorker do
  @moduledoc """
  - recieves a block of text
  - sends off words and their locations to concordance supervisor
  """
  use GenServer
  alias Parsing.TextSection

  def start_link(%TextSection{} = state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(%TextSection{} = state) do
    # IO.inspect state, label: "Started to parse text section"
    {:ok, state, {:continue, nil}}
  end

  @impl true
  def handle_continue(nil, %TextSection{} = state) do
    TextSection.process_text_section(state)
    {:noreply, state}
  end
end
