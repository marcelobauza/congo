require "application_system_test_case"

class ProjectMixesTest < ApplicationSystemTestCase
  setup do
    @project_mix = project_mixes(:one)
  end

  test "visiting the index" do
    visit project_mixes_url
    assert_selector "h1", text: "Project Mixes"
  end

  test "creating a Project mix" do
    visit project_mixes_url
    click_on "New Project Mix"

    fill_in "Bathroom", with: @project_mix.bathroom
    fill_in "Bedroom", with: @project_mix.bedroom
    fill_in "Mix type", with: @project_mix.mix_type
    click_on "Create Project mix"

    assert_text "Project mix was successfully created"
    click_on "Back"
  end

  test "updating a Project mix" do
    visit project_mixes_url
    click_on "Edit", match: :first

    fill_in "Bathroom", with: @project_mix.bathroom
    fill_in "Bedroom", with: @project_mix.bedroom
    fill_in "Mix type", with: @project_mix.mix_type
    click_on "Update Project mix"

    assert_text "Project mix was successfully updated"
    click_on "Back"
  end

  test "destroying a Project mix" do
    visit project_mixes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project mix was successfully destroyed"
  end
end
