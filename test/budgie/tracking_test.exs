defmodule Budgie.TrackingTest do
  use Budgie.DataCase

  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attr = %{
        name: "Test Budget",
        description: "A test budget",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-01-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attr)
      assert budget.name == "Test Budget"
      assert budget.description == "A test budget"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-01-31]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 requires name" do
      user = Budgie.AccountsFixtures.user_fixture()

      invalid_attr = %{
        description: "A test budget",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-01-31],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attr)
      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      user = Budgie.AccountsFixtures.user_fixture()

      invalid_attr = %{
        name: "Test Budget",
        description: "A test budget",
        start_date: ~D[2025-01-31],
        end_date: ~D[2025-01-01],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attr)
      assert changeset.valid? == false
      assert %{end_date: ["end date must be after start date"]} = errors_on(changeset)
      # dbg(changeset)
    end
  end
end
