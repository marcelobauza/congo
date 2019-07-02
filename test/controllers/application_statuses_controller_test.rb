require 'test_helper'

class ApplicationStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_status = application_statuses(:one)
  end

  test "should get index" do
    get application_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_application_status_url
    assert_response :success
  end

  test "should create application_status" do
    assert_difference('ApplicationStatus.count') do
      post application_statuses_url, params: { application_status: { description: @application_status.description, filters: @application_status.filters, layer_type_id: @application_status.layer_type_id, name: @application_status.name, polygon: @application_status.polygon, user_id: @application_status.user_id } }
    end

    assert_redirected_to application_status_url(ApplicationStatus.last)
  end

  test "should show application_status" do
    get application_status_url(@application_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_status_url(@application_status)
    assert_response :success
  end

  test "should update application_status" do
    patch application_status_url(@application_status), params: { application_status: { description: @application_status.description, filters: @application_status.filters, layer_type_id: @application_status.layer_type_id, name: @application_status.name, polygon: @application_status.polygon, user_id: @application_status.user_id } }
    assert_redirected_to application_status_url(@application_status)
  end

  test "should destroy application_status" do
    assert_difference('ApplicationStatus.count', -1) do
      delete application_status_url(@application_status)
    end

    assert_redirected_to application_statuses_url
  end
end
