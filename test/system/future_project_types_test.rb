require "application_system_test_case"

class FutureProjectTypesTest < ApplicationSystemTestCase
  setup do
    @future_project_type = future_project_types(:one)
  end

  test "visiting the index" do
    visit future_project_types_url
    assert_selector "h1", text: "Future Project Types"
  end

  test "creating a Future project type" do
    visit future_project_types_url
    click_on "New Future Project Type"

    fill_in "Abbrev", with: @future_project_type.abbrev
    fill_in "Color", with: @future_project_type.color
    fill_in "Name", with: @future_project_type.name
    click_on "Create Future project type"

    assert_text "Future project type was successfully created"
    click_on "Back"
  end

  test "updating a Future project type" do
    visit future_project_types_url
    click_on "Edit", match: :first

    fill_in "Abbrev", with: @future_project_type.abbrev
    fill_in "Color", with: @future_project_type.color
    fill_in "Name", with: @future_project_type.name
    click_on "Update Future project type"

    assert_text "Future project type was successfully updated"
    click_on "Back"
  end

  test "destroying a Future project type" do
    visit future_project_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Future project type was successfully destroyed"
  end
end
