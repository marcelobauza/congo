require "application_system_test_case"

class ApplicationStatusesTest < ApplicationSystemTestCase
  setup do
    @application_status = application_statuses(:one)
  end

  test "visiting the index" do
    visit application_statuses_url
    assert_selector "h1", text: "Application Statuses"
  end

  test "creating a Application status" do
    visit application_statuses_url
    click_on "New Application Status"

    fill_in "Description", with: @application_status.description
    fill_in "Filters", with: @application_status.filters
    fill_in "Layer type", with: @application_status.layer_type
    fill_in "Name", with: @application_status.name
    fill_in "Polygon", with: @application_status.polygon
    fill_in "User id,", with: @application_status.user_id,
    click_on "Create Application status"

    assert_text "Application status was successfully created"
    click_on "Back"
  end

  test "updating a Application status" do
    visit application_statuses_url
    click_on "Edit", match: :first

    fill_in "Description", with: @application_status.description
    fill_in "Filters", with: @application_status.filters
    fill_in "Layer type", with: @application_status.layer_type
    fill_in "Name", with: @application_status.name
    fill_in "Polygon", with: @application_status.polygon
    fill_in "User id,", with: @application_status.user_id,
    click_on "Update Application status"

    assert_text "Application status was successfully updated"
    click_on "Back"
  end

  test "destroying a Application status" do
    visit application_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Application status was successfully destroyed"
  end
end
