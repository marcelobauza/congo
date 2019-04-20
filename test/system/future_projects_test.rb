require "application_system_test_case"

class FutureProjectsTest < ApplicationSystemTestCase
  setup do
    @future_project = future_projects(:one)
  end

  test "visiting the index" do
    visit future_projects_url
    assert_selector "h1", text: "Future Projects"
  end

  test "creating a Future project" do
    visit future_projects_url
    click_on "New Future Project"

    fill_in "Active", with: @future_project.active
    fill_in "Address", with: @future_project.address
    fill_in "Architect", with: @future_project.architect
    fill_in "Bimester", with: @future_project.bimester
    fill_in "Cadastral date", with: @future_project.cadastral_date
    fill_in "Cadastre", with: @future_project.cadastre
    fill_in "Code", with: @future_project.code
    fill_in "Comments", with: @future_project.comments
    fill_in "County", with: @future_project.county_id
    fill_in "File data", with: @future_project.file_data
    fill_in "File number", with: @future_project.file_number
    fill_in "Floors", with: @future_project.floors
    fill_in "Future project type", with: @future_project.future_project_type_id
    fill_in "Legal agent", with: @future_project.legal_agent
    fill_in "M2 approved", with: @future_project.m2_approved
    fill_in "M2 built", with: @future_project.m2_built
    fill_in "M2 field", with: @future_project.m2_field
    fill_in "Name", with: @future_project.name
    fill_in "Owner", with: @future_project.owner
    fill_in "Project type", with: @future_project.project_type_id
    fill_in "Role number", with: @future_project.role_number
    fill_in "T ofi", with: @future_project.t_ofi
    fill_in "The geom", with: @future_project.the_geom
    fill_in "Total commercials", with: @future_project.total_commercials
    fill_in "Total parking", with: @future_project.total_parking
    fill_in "Total units", with: @future_project.total_units
    fill_in "Undergrounds", with: @future_project.undergrounds
    fill_in "Year", with: @future_project.year
    click_on "Create Future project"

    assert_text "Future project was successfully created"
    click_on "Back"
  end

  test "updating a Future project" do
    visit future_projects_url
    click_on "Edit", match: :first

    fill_in "Active", with: @future_project.active
    fill_in "Address", with: @future_project.address
    fill_in "Architect", with: @future_project.architect
    fill_in "Bimester", with: @future_project.bimester
    fill_in "Cadastral date", with: @future_project.cadastral_date
    fill_in "Cadastre", with: @future_project.cadastre
    fill_in "Code", with: @future_project.code
    fill_in "Comments", with: @future_project.comments
    fill_in "County", with: @future_project.county_id
    fill_in "File data", with: @future_project.file_data
    fill_in "File number", with: @future_project.file_number
    fill_in "Floors", with: @future_project.floors
    fill_in "Future project type", with: @future_project.future_project_type_id
    fill_in "Legal agent", with: @future_project.legal_agent
    fill_in "M2 approved", with: @future_project.m2_approved
    fill_in "M2 built", with: @future_project.m2_built
    fill_in "M2 field", with: @future_project.m2_field
    fill_in "Name", with: @future_project.name
    fill_in "Owner", with: @future_project.owner
    fill_in "Project type", with: @future_project.project_type_id
    fill_in "Role number", with: @future_project.role_number
    fill_in "T ofi", with: @future_project.t_ofi
    fill_in "The geom", with: @future_project.the_geom
    fill_in "Total commercials", with: @future_project.total_commercials
    fill_in "Total parking", with: @future_project.total_parking
    fill_in "Total units", with: @future_project.total_units
    fill_in "Undergrounds", with: @future_project.undergrounds
    fill_in "Year", with: @future_project.year
    click_on "Update Future project"

    assert_text "Future project was successfully updated"
    click_on "Back"
  end

  test "destroying a Future project" do
    visit future_projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Future project was successfully destroyed"
  end
end
