defmodule MovieWeb.MovieCard do
  use Surface.Component

  prop movie, :map, required: true

  defp watch_link(movie) do
    "/watch/#{movie["code"]}"
  end
end
