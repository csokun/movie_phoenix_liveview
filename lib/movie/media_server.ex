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

  def get_movies() do
    GenServer.call(__MODULE__, :get_movies)
  end

  def get_movie(id) when is_binary(id) do
    get_movies()
    |> Enum.find(fn %{"code" => code} -> code == id end)
  end

  def find_movies(search) do
    pattern = ~r/^#{search}/i

    get_movies()
    |> Enum.filter(fn %{"code" => code} ->
      Regex.match?(pattern, code)
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

  def handle_call(:get_movies, _from, %{movies: movies} = state) do
    {:reply, movies, state}
  end

  def handle_call(:get_productions, _from, %{productions: productions} = state) do
    {:reply, productions, state}
  end

  # helpers

  defp extract_productions_from_movies(movies) do
    movies
    |> Enum.group_by(fn %{"production" => proudction} -> proudction end)
    |> Enum.map(fn {production, movies} ->
      %{code: production, movie_count: length(movies)}
    end)
  end
end
