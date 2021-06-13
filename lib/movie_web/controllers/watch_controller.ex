defmodule MovieWeb.WatchController do
  use MovieWeb, :controller

  def index(conn, %{"id" => id}) do
    render(conn, "index.html", movie: Movie.MediaServer.get_movie(id))
  end

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    video = Movie.MediaServer.get_movie(id)
    send_video(conn, headers, video)
  end

  defp send_video(conn, headers, video) do
    offset = get_offset(headers)

    conn
    |> Plug.Conn.put_resp_header("content-type", video.content_type)
    |> Plug.Conn.put_resp_header(
      "content-range",
      "bytes #{offset}-#{video.file_size(-1)}/#{video.file_size}"
    )
    |> Plug.Conn.send_file(200, video.path, offset, video.file_size - offset)
  end

  defp get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_pos} ->
        String.split(start_pos, "-") |> hd |> String.to_integer()

      nil ->
        0
    end
  end
end
