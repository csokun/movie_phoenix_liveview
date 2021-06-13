defmodule Movie.MediaServer do
  use GenServer
  alias Movie.Media

  # Client API 

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(%{path: path} = init_args) do
    movies = Media.get_movies(path)
    state = %{movies: movies, artists: [], options: init_args}
    {:ok, state, {:continue, :loading}}
  end

  def get_movies() do
    GenServer.call(__MODULE__, :get_movies)
  end

  def get_movie(id) when is_binary(id) do
    GenServer.call(__MODULE__, :get_movies)
    |> Enum.find(fn %{code: code} -> code == id end)
  end

  # server callback
  def handle_continue(:loading, state) do
    # scan media
    {:noreply, state}
  end

  def handle_call(:get_movies, _from, %{movies: movies} = state) do
    {:reply, movies, state}
  end
end
