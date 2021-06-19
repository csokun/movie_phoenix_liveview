defmodule Movie.Media do
  def get_movies(path) do
    File.ls!(path)
    |> Enum.filter(fn f -> File.dir?("#{path}/#{f}") end)
    |> Enum.map(fn f ->
      get_metadata(Path.join(path, f))
    end)
  end

  # {file_size: int, path: "", content_type: "video/mp4"}
  defp get_metadata(path) do
    file = Path.join(path, "metadata.json")

    file
    |> File.exists?()
    |> case do
      true ->
        File.read!(file) |> Jason.decode!()

      false ->
        generate_metadata(path)
        get_metadata(path)
    end
  end

  defp generate_metadata(path) do
    code = Path.basename(path)

    ext =
      ["jpg", "jpeg"]
      |> Enum.find(fn extension ->
        File.exists?("#{path}/#{code}.#{extension}")
      end)

    image = "/catalog/#{code}/#{code}.#{ext}"

    video_file = Path.join(path, "#{code}.mp4")
    content_type = MIME.from_path(video_file)
    %{size: file_size} = File.stat!(video_file)

    content =
      %{
        code: code,
        actress: [],
        description: "",
        image: image,
        video_file: video_file,
        content_type: content_type,
        file_size: file_size
      }
      |> Jason.encode!()

    File.write!(Path.join(path, "metadata.json"), content, [:write, {:encoding, :utf8}])
  end
end
