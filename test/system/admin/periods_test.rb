require "application_system_test_case"

class Admin::PeriodsTest < ApplicationSystemTestCase
  setup do
    @admin_period = admin_periods(:one)
  end

  test "visiting the index" do
    visit admin_periods_url
    assert_selector "h1", text: "Admin/Periods"
  end

  test "creating a Period" do
    visit admin_periods_url
    click_on "New Admin/Period"

    fill_in "Active", with: @admin_period.active
    fill_in "Bimester", with: @admin_period.bimester
    fill_in "Year", with: @admin_period.year
    click_on "Create Period"

    assert_text "Period was successfully created"
    click_on "Back"
  end

  test "updating a Period" do
    visit admin_periods_url
    click_on "Edit", match: :first

    fill_in "Active", with: @admin_period.active
    fill_in "Bimester", with: @admin_period.bimester
    fill_in "Year", with: @admin_period.year
    click_on "Update Period"

    assert_text "Period was successfully updated"
    click_on "Back"
  end

  test "destroying a Period" do
    visit admin_periods_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Period was successfully destroyed"
  end
end
