defmodule ConcordanceWebWeb.PageController do
  use ConcordanceWebWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
