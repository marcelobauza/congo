require "application_system_test_case"

class LandUseTypesTest < ApplicationSystemTestCase
  setup do
    @land_use_type = land_use_types(:one)
  end

  test "visiting the index" do
    visit land_use_types_url
    assert_selector "h1", text: "Land Use Types"
  end

  test "creating a Land use type" do
    visit land_use_types_url
    click_on "New Land Use Type"

    fill_in "Abbreviation", with: @land_use_type.abbreviation
    fill_in "Identifier", with: @land_use_type.identifier
    fill_in "Name", with: @land_use_type.name
    click_on "Create Land use type"

    assert_text "Land use type was successfully created"
    click_on "Back"
  end

  test "updating a Land use type" do
    visit land_use_types_url
    click_on "Edit", match: :first

    fill_in "Abbreviation", with: @land_use_type.abbreviation
    fill_in "Identifier", with: @land_use_type.identifier
    fill_in "Name", with: @land_use_type.name
    click_on "Update Land use type"

    assert_text "Land use type was successfully updated"
    click_on "Back"
  end

  test "destroying a Land use type" do
    visit land_use_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Land use type was successfully destroyed"
  end
end
