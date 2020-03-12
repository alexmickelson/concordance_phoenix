defmodule Main do
  @moduledoc """
  1. for your range of numbers get text from gutenburg
  2. parse each text, send results to concordance genserver
  3. mark when completed
  4. generate report of each word and 5 locations it appears
  """
  # https://www.amberbit.com/blog/2017/11/21/structuring-elixir-projects/
  # https://medium.com/pharos-production/process-registry-dynamic-workers-fb9be88cf6fb
  # https://www.thegreatcodeadventure.com/how-we-used-elixirs-genservers-dynamic-supervisors-to-build-concurrent-fault-tolerant-workflows/
  alias Gutenburg.DynamicSupervisor, as: GutenburgSup
  alias Concordance.DynamicSupervisor, as: ConcordanceSup
  alias Concordance.Memory

  # @parsing :parsing_application_supervisor
  def get_books(starting_number, ending_number) do
    Enum.each(starting_number..ending_number, fn id ->
      GutenburgSup.start_child(id)
    end)
  end

  def print_concordance_report() do
    #file = File.open!("concordance.csv", [:write, :utf8])

    report =
    ConcordanceSup.get_children()

    # ConcordanceWeb.Endpoint.broadcast("reports", "new_reports", %{reports: report})
    # :ok = Phoenix.PubSub.subscribe(ConcordanceWeb.PubSub, "reports")
    :ok = Phoenix.PubSub.broadcast(ConcordanceWeb.PubSub, "reports", {:reports, report})
    # |> IO.inspect(limit: 5)
    # |> Enum.sort(fn {word1, _}, {word2, _} -> word1 < word2 end)
    # |> IO.inspect(pretty: true, limit: 500)

    IO.puts("all done.")
  end
end
