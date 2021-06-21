defmodule MovieWeb.WatchLive do
  use MovieWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(movie: %{})}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    movie = Movie.MediaServer.get_movie(id)
    {:noreply, socket |> assign(movie: movie)}
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
end
