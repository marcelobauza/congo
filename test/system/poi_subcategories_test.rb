require "application_system_test_case"

class PoiSubcategoriesTest < ApplicationSystemTestCase
  setup do
    @poi_subcategory = poi_subcategories(:one)
  end

  test "visiting the index" do
    visit poi_subcategories_url
    assert_selector "h1", text: "Poi Subcategories"
  end

  test "creating a Poi subcategory" do
    visit poi_subcategories_url
    click_on "New Poi Subcategory"

    fill_in "Name", with: @poi_subcategory.name
    click_on "Create Poi subcategory"

    assert_text "Poi subcategory was successfully created"
    click_on "Back"
  end

  test "updating a Poi subcategory" do
    visit poi_subcategories_url
    click_on "Edit", match: :first

    fill_in "Name", with: @poi_subcategory.name
    click_on "Update Poi subcategory"

    assert_text "Poi subcategory was successfully updated"
    click_on "Back"
  end

  test "destroying a Poi subcategory" do
    visit poi_subcategories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Poi subcategory was successfully destroyed"
  end
end
