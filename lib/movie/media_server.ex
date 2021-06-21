defmodule Movie.MediaServer do
  use GenServer
  alias Movie.Media

  # Client API 

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(init_args) do
    state = %{
      movies: [],
      productions: [],
      artists: [],
      options: init_args
    }

    {:ok, state, {:continue, :loading}}
  end

  def save_metadata(movie) do
    GenServer.cast(__MODULE__, {:save_metadata, movie})
  end

  def handle_cast({:save_metadata, movie}, state) do
    %{options: %{path: path}} = state
    %{"code" => code} = movie
    Media.save_metadata(movie, path)

    movies =
      state.movies
      |> Enum.map(fn
        %{"code" => ^code} -> movie
        item -> item
      end)

    {:noreply, %{state | movies: movies}}
  end

  def get_movies() do
    GenServer.call(__MODULE__, :get_movies)
  end

  def get_movie(id) when is_binary(id) do
    get_movies()
    |> Enum.find(fn %{"code" => code} -> code == id end)
  end

  def find_movies(search) do
    pattern = ~r/#{search}/i
    searchable_fields = ["code", "performers", "description"]

    get_movies()
    |> Enum.filter(fn movie ->
      searchable_fields
      |> Enum.any?(fn field ->
        Regex.match?(pattern, movie["#{field}"] || "")
      end)
    end)
  end

  def get_productions() do
    GenServer.call(__MODULE__, :get_productions)
  end

  # server callback
  def handle_continue(:loading, state) do
    %{path: path} = state.options
    # scan media
    movies = Media.get_movies(path)
    productions = extract_productions_from_movies(movies)
    {:noreply, %{state | movies: movies, productions: productions}}
  end

  def handle_call(:get_movies, _from, %{movies: movies} = state), do: {:reply, movies, state}

  def handle_call(:get_productions, _from, %{productions: productions} = state),
    do: {:reply, productions, state}

  def handle_call(:get_catalog_path, _from, %{options: %{path: path}} = state),
    do: {:reply, path, state}

  # helpers

  defp extract_productions_from_movies(movies) do
    movies
    |> Enum.group_by(fn %{"production" => proudction} -> proudction end)
    |> Enum.map(fn {production, movies} ->
      %{code: production, movie_count: length(movies)}
    end)
  end
end
