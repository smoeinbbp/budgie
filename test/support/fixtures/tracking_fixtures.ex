defmodule Budgie.TrackingFixtures do
  def valid_budget_attrs(attrs \\ %{}) do
    attrs
    |> add_creator_if_necessary()
    |> Enum.into(%{
      name: "Test Budget",
      description: "A test budget",
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-01-31]
    })
  end

  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> valid_budget_attrs()
      |> Budgie.Tracking.create_budget()

    budget
  end

  defp add_creator_if_necessary(attrs) when is_map(attrs) do
    Map.put_new_lazy(attrs, :creator_id, fn ->
      user = Budgie.AccountsFixtures.user_fixture()
      user.id
    end)
  end
end
