defmodule MovieWeb.ProductTag do
  use Surface.Component

  alias Surface.Components.LivePatch

  prop production, :map, required: true, default: %{}

  defp link_to(%{code: code}), do: "?q=#{code}"
end
