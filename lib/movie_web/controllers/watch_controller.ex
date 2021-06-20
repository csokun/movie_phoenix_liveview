defmodule MovieWeb.WatchController do
  use MovieWeb, :controller

  def index(conn, %{"id" => id}) do
    render(conn, "index.html", movie: Movie.MediaServer.get_movie(id))
  end

  def show(%{method: "HEAD"} = conn, %{"id" => id}) do
    %{"content_type" => content_type, "file_size" => file_size} = Movie.MediaServer.get_movie(id)

    conn
    |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
    |> Plug.Conn.put_resp_header("content-type", content_type)
    |> Plug.Conn.put_resp_header("content-length", file_size)
    |> halt()
  end

  def show(%{req_headers: headers, method: "GET"} = conn, %{"id" => id}) do
    video = Movie.MediaServer.get_movie(id)
    send_video(conn, headers, video)
  end

  defp send_video(conn, headers, %{
         "content_type" => content_type,
         "file_size" => file_size,
         "video_file" => video_file
       }) do
    offset = get_offset(headers)

    conn
    |> Plug.Conn.put_resp_header("content-type", content_type)
    |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
    |> Plug.Conn.put_resp_header(
      "content-range",
      "bytes #{offset}-#{file_size - 1}/#{file_size}"
    )
    |> Plug.Conn.send_file(206, video_file, offset, file_size - offset)
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
