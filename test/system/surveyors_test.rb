require "application_system_test_case"

class SurveyorsTest < ApplicationSystemTestCase
  setup do
    @surveyor = surveyors(:one)
  end

  test "visiting the index" do
    visit surveyors_url
    assert_selector "h1", text: "Surveyors"
  end

  test "creating a Surveyor" do
    visit surveyors_url
    click_on "New Surveyor"

    fill_in "Name", with: @surveyor.name
    click_on "Create Surveyor"

    assert_text "Surveyor was successfully created"
    click_on "Back"
  end

  test "updating a Surveyor" do
    visit surveyors_url
    click_on "Edit", match: :first

    fill_in "Name", with: @surveyor.name
    click_on "Update Surveyor"

    assert_text "Surveyor was successfully updated"
    click_on "Back"
  end

  test "destroying a Surveyor" do
    visit surveyors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Surveyor was successfully destroyed"
  end
end
