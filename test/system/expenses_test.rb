require "application_system_test_case"

class ExpensesTest < ApplicationSystemTestCase
  setup do
    @expense = expenses(:one)
  end

  test "visiting the index" do
    visit expenses_url
    assert_selector "h1", text: "Expenses"
  end

  test "creating a Expense" do
    visit expenses_url
    click_on "New Expense"

    fill_in "Abc1", with: @expense.abc1
    fill_in "C2", with: @expense.c2
    fill_in "C3", with: @expense.c3
    fill_in "D", with: @expense.d
    fill_in "E", with: @expense.e
    fill_in "Expense type", with: @expense.expense_type_id
    check "Santiago only" if @expense.santiago_only
    click_on "Create Expense"

    assert_text "Expense was successfully created"
    click_on "Back"
  end

  test "updating a Expense" do
    visit expenses_url
    click_on "Edit", match: :first

    fill_in "Abc1", with: @expense.abc1
    fill_in "C2", with: @expense.c2
    fill_in "C3", with: @expense.c3
    fill_in "D", with: @expense.d
    fill_in "E", with: @expense.e
    fill_in "Expense type", with: @expense.expense_type_id
    check "Santiago only" if @expense.santiago_only
    click_on "Update Expense"

    assert_text "Expense was successfully updated"
    click_on "Back"
  end

  test "destroying a Expense" do
    visit expenses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expense was successfully destroyed"
  end
end
