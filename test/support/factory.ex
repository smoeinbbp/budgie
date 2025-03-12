defmodule Budgie.Factory do
  use ExMachina.Ecto, repo: Budgie.Repo

  alias Budgie.Accounts
  alias Budgie.Tracking

  def user_factory do
    %Accounts.User{
      name: sequence(:user_name, &"Christian Alexander #{&1}"),
      email: sequence(:user_email, &"email-#{&1}@example.com"),
      hashed_password: "_"
    }
  end

  def budget_factory do
    %Tracking.Budget{
      name: sequence(:budget_name, &"Budget #{&1}"),
      description: sequence(:budget_description, &"Budget Description #{&1}"),
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-12-31],
      creator: build(:user)
    }
  end

  def budget_transaction_factory do
    %Tracking.BudgetTransaction{
      effective_date: ~D[2025-01-01],
      amount: Decimal.new("123.45"),
      description: sequence(:transaction_description, &"Transaction Description #{&1}"),
      budget: build(:budget),
      type: :spending
    }
  end
end
