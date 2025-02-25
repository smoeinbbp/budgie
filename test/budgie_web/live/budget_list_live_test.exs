defmodule BudgieWeb.BudgetListLiveTest do
  use BudgieWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgie.TrackingFixtures

  alias Budgie.Tracking

  setup do
    user = Budgie.AccountsFixtures.user_fixture()
    %{user: user}
  end

  describe "Index view" do
    test "shows budget when one exists", %{conn: conn, user: user} do
      budget = budget_fixture(%{creator_id: user.id})
      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/budgets")

      # open_browser(lv)
      assert html =~ budget.name
      assert html =~ budget.description
    end
  end

  describe "Create Budget Modal" do
    test "modal is presented", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")
      assert has_element?(lv, "#create-budget-modal")
    end

    test "validatation errors are presented when form is changed with invalid input", %{
      conn: conn,
      user: user
    } do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = element(lv, "#create-budget-modal form")

      html =
        render_change(form, %{
          "budget" => %{"name" => ""}
        })

      assert html =~ html_escape("can't be blank")
    end

    test "create budget", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = element(lv, "#create-budget-modal form")

      {:ok, _lv, html} =
        render_submit(form, %{
          "budget" => %{
            "name" => "Test Budget",
            "description" => "A test budget",
            "start_date" => "2025-01-01",
            "end_date" => "2025-01-31"
          }
        })
        |> follow_redirect(conn)

      assert html =~ html_escape("Budget created successfully")

      assert [created_budget] = Tracking.list_budgets()
      assert created_budget.name == "Test Budget"
      assert created_budget.description == "A test budget"
      assert created_budget.start_date == ~D[2025-01-01]
      assert created_budget.end_date == ~D[2025-01-31]
    end
  end
end
