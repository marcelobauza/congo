require "application_system_test_case"

class RentProjectsTest < ApplicationSystemTestCase
  setup do
    @rent_project = rent_projects(:one)
  end

  test "visiting the index" do
    visit rent_projects_url
    assert_selector "h1", text: "Rent Projects"
  end

  test "creating a Rent project" do
    visit rent_projects_url
    click_on "New Rent Project"

    fill_in "Bathroom", with: @rent_project.bathroom
    fill_in "Bedroom", with: @rent_project.bedroom
    fill_in "Bimester", with: @rent_project.bimester
    fill_in "Catastral date", with: @rent_project.catastral_date
    fill_in "Code", with: @rent_project.code
    fill_in "County", with: @rent_project.county_id
    fill_in "Floors", with: @rent_project.floors
    fill_in "Half bedroom", with: @rent_project.half_bedroom
    fill_in "Name", with: @rent_project.name
    fill_in "Offer", with: @rent_project.offer
    fill_in "Population per building", with: @rent_project.population_per_building
    fill_in "Price", with: @rent_project.price
    fill_in "Project type", with: @rent_project.project_type_id
    fill_in "Sale date", with: @rent_project.sale_date
    fill_in "Square meters terrain", with: @rent_project.square_meters_terrain
    fill_in "Surface util", with: @rent_project.surface_util
    fill_in "Terrace", with: @rent_project.terrace
    fill_in "The geom", with: @rent_project.the_geom
    fill_in "Total beds", with: @rent_project.total_beds
    fill_in "Uf terrain", with: @rent_project.uf_terrain
    fill_in "Year", with: @rent_project.year
    click_on "Create Rent project"

    assert_text "Rent project was successfully created"
    click_on "Back"
  end

  test "updating a Rent project" do
    visit rent_projects_url
    click_on "Edit", match: :first

    fill_in "Bathroom", with: @rent_project.bathroom
    fill_in "Bedroom", with: @rent_project.bedroom
    fill_in "Bimester", with: @rent_project.bimester
    fill_in "Catastral date", with: @rent_project.catastral_date
    fill_in "Code", with: @rent_project.code
    fill_in "County", with: @rent_project.county_id
    fill_in "Floors", with: @rent_project.floors
    fill_in "Half bedroom", with: @rent_project.half_bedroom
    fill_in "Name", with: @rent_project.name
    fill_in "Offer", with: @rent_project.offer
    fill_in "Population per building", with: @rent_project.population_per_building
    fill_in "Price", with: @rent_project.price
    fill_in "Project type", with: @rent_project.project_type_id
    fill_in "Sale date", with: @rent_project.sale_date
    fill_in "Square meters terrain", with: @rent_project.square_meters_terrain
    fill_in "Surface util", with: @rent_project.surface_util
    fill_in "Terrace", with: @rent_project.terrace
    fill_in "The geom", with: @rent_project.the_geom
    fill_in "Total beds", with: @rent_project.total_beds
    fill_in "Uf terrain", with: @rent_project.uf_terrain
    fill_in "Year", with: @rent_project.year
    click_on "Update Rent project"

    assert_text "Rent project was successfully updated"
    click_on "Back"
  end

  test "destroying a Rent project" do
    visit rent_projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rent project was successfully destroyed"
  end
end
