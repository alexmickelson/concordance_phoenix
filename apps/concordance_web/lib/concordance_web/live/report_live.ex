defmodule ConcordanceWeb.ReportLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(ConcordanceWeb.PubSub, "reports")
    ConcordanceWeb.Endpoint.subscribe("reports")
    IO.inspect(self(), label: "liveview pid")
    {:ok, assign(socket, :reports, [])}
  end

  def render(assigns) do
    IO.inspect(self(), label: "render pid")
    # IO.inspect(assigns, label: "assigns")
    ~L"""
    <h1>Concordance Report</h1>
    <%= for report <- @reports do %>
      <table>
        <tr>
            <td><h3><%= report.word %></h3></td>
            <td>Word Index</td>
            <td>Title</td>
        </tr>
          <%= for location <- report.locations do %>
            <tr>
              <td></td>
              <td><%= location.word_number %></td>
              <td><%= location.book %></td>
            </tr>
          <% end %>
      </table>
    <% end %>
    """
  end


  def handle_params(_params, _uri, socket) do
    IO.puts "params"
    {:noreply, socket}
  end


  def handle_info({:reports, reports}, socket) do
    # IO.inspect(message, label: "recieved message")
    {:noreply, assign(socket, :reports, reports)}
  end

end
