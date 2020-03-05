defmodule ConcordanceWeb.ConcordanceController do
  use ConcordanceWeb, :controller

  def show(conn, _params) do
    report = Main.print_concordance_report()
    render conn, "report.html", report: report
  end
end
