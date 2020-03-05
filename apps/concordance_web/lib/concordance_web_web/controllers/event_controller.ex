defmodule ConcordanceWebWeb.EventController do
  use ConcordanceWebWeb, :controller

  def show(conn, %{"id" => id}) do
    event = %{
      id: id,
      title: "some title",
      location: "ephraim"
    }
    render conn, "details.html", event: event
  end
  
end
