defmodule MovieWeb.MovieCard do
  use Surface.Component

  prop movie, :map, required: true

  defp watch_link(movie) do
    "/watch/#{movie["code"]}"
  end

  defp get_tags(nil), do: []
  defp get_tags(""), do: []

  defp get_tags(tags) do
    tags
    |> String.split(";")
  end

  defp get_image(movie) do
    [movie["catalog_id"], movie["image"]] |> Enum.join("/")
  end
end
