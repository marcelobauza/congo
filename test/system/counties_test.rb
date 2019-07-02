require "application_system_test_case"

class CountiesTest < ApplicationSystemTestCase
  setup do
    @county = counties(:one)
  end

  test "visiting the index" do
    visit counties_url
    assert_selector "h1", text: "Counties"
  end

  test "creating a County" do
    visit counties_url
    click_on "New County"

    fill_in "Code", with: @county.code
    fill_in "Code sii", with: @county.code_sii
    fill_in "Commercial project data", with: @county.commercial_project_data
    fill_in "Demography data", with: @county.demography_data
    fill_in "Future project data", with: @county.future_project_data
    fill_in "Legislation data", with: @county.legislation_data
    fill_in "Name", with: @county.name
    fill_in "Number last project future", with: @county.number_last_project_future
    fill_in "Sales project data", with: @county.sales_project_data
    fill_in "Transaction data", with: @county.transaction_data
    click_on "Create County"

    assert_text "County was successfully created"
    click_on "Back"
  end

  test "updating a County" do
    visit counties_url
    click_on "Edit", match: :first

    fill_in "Code", with: @county.code
    fill_in "Code sii", with: @county.code_sii
    fill_in "Commercial project data", with: @county.commercial_project_data
    fill_in "Demography data", with: @county.demography_data
    fill_in "Future project data", with: @county.future_project_data
    fill_in "Legislation data", with: @county.legislation_data
    fill_in "Name", with: @county.name
    fill_in "Number last project future", with: @county.number_last_project_future
    fill_in "Sales project data", with: @county.sales_project_data
    fill_in "Transaction data", with: @county.transaction_data
    click_on "Update County"

    assert_text "County was successfully updated"
    click_on "Back"
  end

  test "destroying a County" do
    visit counties_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "County was successfully destroyed"
  end
end
