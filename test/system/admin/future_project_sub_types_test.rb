require "application_system_test_case"

class Admin::FutureProjectSubTypesTest < ApplicationSystemTestCase
  setup do
    @admin_future_project_sub_type = admin_future_project_sub_types(:one)
  end

  test "visiting the index" do
    visit admin_future_project_sub_types_url
    assert_selector "h1", text: "Admin/Future Project Sub Types"
  end

  test "creating a Future project sub type" do
    visit admin_future_project_sub_types_url
    click_on "New Admin/Future Project Sub Type"

    fill_in "Name", with: @admin_future_project_sub_type.name
    click_on "Create Future project sub type"

    assert_text "Future project sub type was successfully created"
    click_on "Back"
  end

  test "updating a Future project sub type" do
    visit admin_future_project_sub_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @admin_future_project_sub_type.name
    click_on "Update Future project sub type"

    assert_text "Future project sub type was successfully updated"
    click_on "Back"
  end

  test "destroying a Future project sub type" do
    visit admin_future_project_sub_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Future project sub type was successfully destroyed"
  end
end
