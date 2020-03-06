defmodule ConcordanceWeb.ReportChannel do
  use Phoenix.Channel

  def join("report:get", _message, socket) do
    {:ok, socket}
  end

  def send_update(new_report) do
    payload = %{
      "report" => new_report
    }
    ConcordanceWeb.Endpoint.broadcast!("report:get", "update report", payload)
  end

end
