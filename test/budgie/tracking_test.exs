defmodule Budgie.TrackingTest do
  use Budgie.DataCase

  import Budgie.TrackingFixtures
  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      attrs = params_with_assocs(:budget)

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(attrs)
      assert budget.name == attrs.name
      assert budget.description == attrs.description
      assert budget.start_date == attrs.start_date
      assert budget.end_date == attrs.end_date
      assert budget.creator_id == attrs.creator_id
    end

    test "create_budget/2 requires name" do
      user = Budgie.AccountsFixtures.user_fixture()

      invalid_attr =
        valid_budget_attrs(%{creator_id: user.id})
        |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attr)
      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      invalid_attr =
        valid_budget_attrs()
        |> Map.merge(%{
          start_date: ~D[2025-01-31],
          end_date: ~D[2025-01-01]
        })

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attr)
      assert changeset.valid? == false
      assert %{end_date: ["end date must be after start date"]} = errors_on(changeset)
      # dbg(changeset)
    end
  end
end
