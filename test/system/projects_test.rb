require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "creating a Project" do
    visit projects_url
    click_on "New Project"

    fill_in "0", with: @project.0
    fill_in "Default", with: @project.DEFAULT
    fill_in "Address", with: @project.address
    fill_in "Agency", with: @project.agency_id
    fill_in "Build date", with: @project.build_date
    fill_in "Code", with: @project.code
    fill_in "County", with: @project.county_id
    fill_in "Elevators", with: @project.elevators
    fill_in "Floors", with: @project.floors
    fill_in "General observation", with: @project.general_observation
    fill_in "Integer", with: @project.integer
    fill_in "Name", with: @project.name
    fill_in "Pilot opening date", with: @project.pilot_opening_date
    fill_in "Project type", with: @project.project_type_id
    fill_in "Quantity department for floor", with: @project.quantity_department_for_floor
    fill_in "Sale date", with: @project.sale_date
    fill_in "The geom", with: @project.the_geom
    fill_in "Transfer date", with: @project.transfer_date
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "updating a Project" do
    visit projects_url
    click_on "Edit", match: :first

    fill_in "0", with: @project.0
    fill_in "Default", with: @project.DEFAULT
    fill_in "Address", with: @project.address
    fill_in "Agency", with: @project.agency_id
    fill_in "Build date", with: @project.build_date
    fill_in "Code", with: @project.code
    fill_in "County", with: @project.county_id
    fill_in "Elevators", with: @project.elevators
    fill_in "Floors", with: @project.floors
    fill_in "General observation", with: @project.general_observation
    fill_in "Integer", with: @project.integer
    fill_in "Name", with: @project.name
    fill_in "Pilot opening date", with: @project.pilot_opening_date
    fill_in "Project type", with: @project.project_type_id
    fill_in "Quantity department for floor", with: @project.quantity_department_for_floor
    fill_in "Sale date", with: @project.sale_date
    fill_in "The geom", with: @project.the_geom
    fill_in "Transfer date", with: @project.transfer_date
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "destroying a Project" do
    visit projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project was successfully destroyed"
  end
end
