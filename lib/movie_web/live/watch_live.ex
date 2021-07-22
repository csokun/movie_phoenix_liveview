defmodule MovieWeb.WatchLive do
  use Surface.LiveView

  alias MovieWeb.{MovieCard}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(movie: %{})}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    movie = Movie.MediaServer.get_movie(id)

    movies = find_related_movies(movie)

    {:noreply,
     socket
     |> assign(movie: movie)
     |> assign(movies: movies)}
  end

  @impl true
  def handle_event("update", %{"code" => id} = movie, socket) do
    existing = Movie.MediaServer.get_movie(id)
    saved = Map.merge(existing, movie)

    Movie.MediaServer.save_metadata(saved)

    {:noreply,
     socket
     |> put_flash(:info, "Movie metadata saved!")
     |> assign(movie: saved)}
  end

  defp find_related_movies(%{"performers" => performers}) when performers == "", do: []

  defp find_related_movies(movie) do
    Movie.MediaServer.find_movies(movie["performers"])
    |> Enum.filter(fn %{"code" => code} -> code != movie["code"] end)
    |> Enum.sort_by(& &1["code"])
  end

  defp get_image(movie) do
    [movie["catalog_id"], movie["image"]] |> Enum.join("/")
  end

  defp get_stream_url(movie) do
    ["/stream", movie["code"]] |> Enum.join("/")
  end
end
