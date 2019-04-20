require "application_system_test_case"

class PropertyTypesTest < ApplicationSystemTestCase
  setup do
    @property_type = property_types(:one)
  end

  test "visiting the index" do
    visit property_types_url
    assert_selector "h1", text: "Property Types"
  end

  test "creating a Property type" do
    visit property_types_url
    click_on "New Property Type"

    fill_in "Description", with: @property_type.description
    fill_in "Name", with: @property_type.name
    click_on "Create Property type"

    assert_text "Property type was successfully created"
    click_on "Back"
  end

  test "updating a Property type" do
    visit property_types_url
    click_on "Edit", match: :first

    fill_in "Description", with: @property_type.description
    fill_in "Name", with: @property_type.name
    click_on "Update Property type"

    assert_text "Property type was successfully updated"
    click_on "Back"
  end

  test "destroying a Property type" do
    visit property_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Property type was successfully destroyed"
  end
end
