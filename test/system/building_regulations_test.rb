require "application_system_test_case"

class BuildingRegulationsTest < ApplicationSystemTestCase
  setup do
    @building_regulation = building_regulations(:one)
  end

  test "visiting the index" do
    visit building_regulations_url
    assert_selector "h1", text: "Building Regulations"
  end

  test "creating a Building regulation" do
    visit building_regulations_url
    click_on "New Building Regulation"

    fill_in "Am cc", with: @building_regulation.am_cc
    fill_in "Aminciti", with: @building_regulation.aminciti
    fill_in "Building zone", with: @building_regulation.building_zone
    fill_in "Comments", with: @building_regulation.comments
    fill_in "Construct", with: @building_regulation.construct
    fill_in "County", with: @building_regulation.county_id
    fill_in "Density type", with: @building_regulation.density_type_id
    fill_in "Grouping", with: @building_regulation.grouping
    fill_in "Hectarea inhabitants", with: @building_regulation.hectarea_inhabitants
    fill_in "Icinciti", with: @building_regulation.icinciti
    fill_in "Identifier", with: @building_regulation.identifier
    fill_in "Land ocupation", with: @building_regulation.land_ocupation
    fill_in "Osinciti", with: @building_regulation.osinciti
    fill_in "Parkings", with: @building_regulation.parkings
    fill_in "Site", with: @building_regulation.site
    fill_in "The geom", with: @building_regulation.the_geom
    click_on "Create Building regulation"

    assert_text "Building regulation was successfully created"
    click_on "Back"
  end

  test "updating a Building regulation" do
    visit building_regulations_url
    click_on "Edit", match: :first

    fill_in "Am cc", with: @building_regulation.am_cc
    fill_in "Aminciti", with: @building_regulation.aminciti
    fill_in "Building zone", with: @building_regulation.building_zone
    fill_in "Comments", with: @building_regulation.comments
    fill_in "Construct", with: @building_regulation.construct
    fill_in "County", with: @building_regulation.county_id
    fill_in "Density type", with: @building_regulation.density_type_id
    fill_in "Grouping", with: @building_regulation.grouping
    fill_in "Hectarea inhabitants", with: @building_regulation.hectarea_inhabitants
    fill_in "Icinciti", with: @building_regulation.icinciti
    fill_in "Identifier", with: @building_regulation.identifier
    fill_in "Land ocupation", with: @building_regulation.land_ocupation
    fill_in "Osinciti", with: @building_regulation.osinciti
    fill_in "Parkings", with: @building_regulation.parkings
    fill_in "Site", with: @building_regulation.site
    fill_in "The geom", with: @building_regulation.the_geom
    click_on "Update Building regulation"

    assert_text "Building regulation was successfully updated"
    click_on "Back"
  end

  test "destroying a Building regulation" do
    visit building_regulations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Building regulation was successfully destroyed"
  end
end
