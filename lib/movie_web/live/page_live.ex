defmodule MovieWeb.PageLive do
  use MovieWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    movies =
      Movie.MediaServer.get_movies()
      |> Enum.take_random(10)
      |> IO.inspect()

    {:ok, assign(socket, query: "", movies: movies)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "No movies found matching \"#{query}\"")
         |> assign(movies: [], query: query)}

      movies ->
        {:noreply,
         socket
         |> assign(:movies, movies)
         |> assign(:query, query)}
    end
  end

  defp search(query) do
    movies = Movie.MediaServer.find_movies(query)

    case length(movies) == 0 do
      true -> nil
      false -> movies
    end
  end
end
