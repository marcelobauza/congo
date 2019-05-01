require "application_system_test_case"

class ProjectInstancesTest < ApplicationSystemTestCase
  setup do
    @project_instance = project_instances(:one)
  end

  test "visiting the index" do
    visit project_instances_url
    assert_selector "h1", text: "Project Instances"
  end

  test "creating a Project instance" do
    visit project_instances_url
    click_on "New Project Instance"

    fill_in "Default", with: @project_instance.DEFAULT
    fill_in "Active", with: @project_instance.active
    fill_in "Bimester", with: @project_instance.bimester
    fill_in "Cadastre", with: @project_instance.cadastre
    fill_in "Comments", with: @project_instance.comments
    fill_in "False", with: @project_instance.false
    fill_in "Project", with: @project_instance.project_id
    fill_in "Project status", with: @project_instance.project_status_id
    fill_in "True", with: @project_instance.true
    fill_in "Validated", with: @project_instance.validated
    fill_in "Year", with: @project_instance.year
    click_on "Create Project instance"

    assert_text "Project instance was successfully created"
    click_on "Back"
  end

  test "updating a Project instance" do
    visit project_instances_url
    click_on "Edit", match: :first

    fill_in "Default", with: @project_instance.DEFAULT
    fill_in "Active", with: @project_instance.active
    fill_in "Bimester", with: @project_instance.bimester
    fill_in "Cadastre", with: @project_instance.cadastre
    fill_in "Comments", with: @project_instance.comments
    fill_in "False", with: @project_instance.false
    fill_in "Project", with: @project_instance.project_id
    fill_in "Project status", with: @project_instance.project_status_id
    fill_in "True", with: @project_instance.true
    fill_in "Validated", with: @project_instance.validated
    fill_in "Year", with: @project_instance.year
    click_on "Update Project instance"

    assert_text "Project instance was successfully updated"
    click_on "Back"
  end

  test "destroying a Project instance" do
    visit project_instances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project instance was successfully destroyed"
  end
end
