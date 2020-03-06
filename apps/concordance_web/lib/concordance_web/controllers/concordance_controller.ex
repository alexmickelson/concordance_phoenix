defmodule ConcordanceWeb.ConcordanceController do
  use ConcordanceWeb, :controller

  def show(conn, _params) do
    report = Main.print_concordance_report()
    render conn, "report.html", report: report
  end

  def add(conn, %{"book_range" => %{"ending_id" => ending_id, "starting_id" => starting_id}}) do

    Main.get_books(String.to_integer(starting_id), String.to_integer(ending_id))
    redirect conn, to: Routes.concordance_path(conn, :show)
  end
end
