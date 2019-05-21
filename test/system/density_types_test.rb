require "application_system_test_case"

class DensityTypesTest < ApplicationSystemTestCase
  setup do
    @density_type = density_types(:one)
  end

  test "visiting the index" do
    visit density_types_url
    assert_selector "h1", text: "Density Types"
  end

  test "creating a Density type" do
    visit density_types_url
    click_on "New Density Type"

    fill_in "Color", with: @density_type.color
    fill_in "Identifier", with: @density_type.identifier
    fill_in "Name", with: @density_type.name
    fill_in "Position", with: @density_type.position
    click_on "Create Density type"

    assert_text "Density type was successfully created"
    click_on "Back"
  end

  test "updating a Density type" do
    visit density_types_url
    click_on "Edit", match: :first

    fill_in "Color", with: @density_type.color
    fill_in "Identifier", with: @density_type.identifier
    fill_in "Name", with: @density_type.name
    fill_in "Position", with: @density_type.position
    click_on "Update Density type"

    assert_text "Density type was successfully updated"
    click_on "Back"
  end

  test "destroying a Density type" do
    visit density_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Density type was successfully destroyed"
  end
end
