require "application_system_test_case"

class ImportProcessesTest < ApplicationSystemTestCase
  setup do
    @import_process = import_processes(:one)
  end

  test "visiting the index" do
    visit import_processes_url
    assert_selector "h1", text: "Import Processes"
  end

  test "creating a Import process" do
    visit import_processes_url
    click_on "New Import Process"

    fill_in "Data source", with: @import_process.data_source
    fill_in "Failed", with: @import_process.failed
    fill_in "File path", with: @import_process.file_path
    fill_in "Inserted", with: @import_process.inserted
    fill_in "Original filename", with: @import_process.original_filename
    fill_in "Processed", with: @import_process.processed
    fill_in "Status", with: @import_process.status
    fill_in "Updated", with: @import_process.updated
    fill_in "User", with: @import_process.user_id
    click_on "Create Import process"

    assert_text "Import process was successfully created"
    click_on "Back"
  end

  test "updating a Import process" do
    visit import_processes_url
    click_on "Edit", match: :first

    fill_in "Data source", with: @import_process.data_source
    fill_in "Failed", with: @import_process.failed
    fill_in "File path", with: @import_process.file_path
    fill_in "Inserted", with: @import_process.inserted
    fill_in "Original filename", with: @import_process.original_filename
    fill_in "Processed", with: @import_process.processed
    fill_in "Status", with: @import_process.status
    fill_in "Updated", with: @import_process.updated
    fill_in "User", with: @import_process.user_id
    click_on "Update Import process"

    assert_text "Import process was successfully updated"
    click_on "Back"
  end

  test "destroying a Import process" do
    visit import_processes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Import process was successfully destroyed"
  end
end
