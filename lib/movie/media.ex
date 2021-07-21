defmodule Movie.Media do
  def get_movies(path, catalog_id) do
    File.ls!(path)
    |> Enum.filter(fn f -> File.dir?("#{path}/#{f}") end)
    |> Enum.map(fn f ->
      metadata = get_metadata(Path.join(path, f))

      video_file = "#{path}/#{metadata["code"]}/#{metadata["code"]}.mp4"

      metadata
      |> put_in(["image"], metadata["image"] |> String.replace("/catalog", ""))
      |> put_in(["video_file"], video_file)
      |> put_in(["path"], path)
      |> put_in(["catalog_id"], catalog_id)
    end)
  end

  def save_metadata(%{"code" => code, "path" => catalog_path} = movie) do
    metadata_file = Path.join([catalog_path, code, "metadata.json"])
    File.write!(metadata_file, Jason.encode!(movie), [:write, {:encoding, :utf8}])
  end

  defp get_metadata(path) do
    file = Path.join(path, "metadata.json")

    file
    |> File.exists?()
    |> case do
      true ->
        File.read!(file) |> Jason.decode!()

      false ->
        generate_metadata(path)
    end
  end

  defp generate_metadata(path) do
    code = Path.basename(path)

    ext =
      ["jpg", "jpeg"]
      |> Enum.find(fn extension ->
        File.exists?("#{path}/#{code}.#{extension}")
      end)

    image = "/#{code}/#{code}.#{ext}"

    video_file = Path.join(path, "#{code}.mp4")
    content_type = MIME.from_path(video_file)
    %{size: file_size} = File.stat!(video_file)

    %{
      "code" => code,
      "catalog_id" => "",
      "performers" => "",
      "description" => "",
      "production" => code |> String.split("-") |> hd,
      "tags" => "",
      "image" => image,
      "video_file" => video_file,
      "content_type" => content_type,
      "file_size" => file_size
    }
  end
end
