defmodule MovieWeb.SearchInput do
  use Surface.Component

  prop id, :string, default: "q"
  prop query, :string, default: ""

  def render(assigns) do
    ~F"""
      <button class="absolute top-2 right-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 opacity-60" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </button>
      <input class="w-full px-2 py-2 text-sm border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:border-indigo-500 focus:ring-1"
             phx-debounce="300"
             placeholder="Search"
             name={@id}
             id={@id}
             value={@query} />
    """
  end
end
