defmodule ConcordanceWeb.EventController do
  use ConcordanceWeb, :controller

  def show(conn, %{"id" => id}) do
    event = %{
      id: id,
      title: "some title",
      location: "ephraim"
    }
    render conn, "details.html", event: event
  end

end
