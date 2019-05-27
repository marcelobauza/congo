require 'test_helper'

class ImportProcessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @import_process = import_processes(:one)
  end

  test "should get index" do
    get import_processes_url
    assert_response :success
  end

  test "should get new" do
    get new_import_process_url
    assert_response :success
  end

  test "should create import_process" do
    assert_difference('ImportProcess.count') do
      post import_processes_url, params: { import_process: { data_source: @import_process.data_source, failed: @import_process.failed, file_path: @import_process.file_path, inserted: @import_process.inserted, original_filename: @import_process.original_filename, processed: @import_process.processed, status: @import_process.status, updated: @import_process.updated, user_id: @import_process.user_id } }
    end

    assert_redirected_to import_process_url(ImportProcess.last)
  end

  test "should show import_process" do
    get import_process_url(@import_process)
    assert_response :success
  end

  test "should get edit" do
    get edit_import_process_url(@import_process)
    assert_response :success
  end

  test "should update import_process" do
    patch import_process_url(@import_process), params: { import_process: { data_source: @import_process.data_source, failed: @import_process.failed, file_path: @import_process.file_path, inserted: @import_process.inserted, original_filename: @import_process.original_filename, processed: @import_process.processed, status: @import_process.status, updated: @import_process.updated, user_id: @import_process.user_id } }
    assert_redirected_to import_process_url(@import_process)
  end

  test "should destroy import_process" do
    assert_difference('ImportProcess.count', -1) do
      delete import_process_url(@import_process)
    end

    assert_redirected_to import_processes_url
  end
end
