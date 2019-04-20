require 'test_helper'

class FutureProjectTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @future_project_type = future_project_types(:one)
  end

  test "should get index" do
    get future_project_types_url
    assert_response :success
  end

  test "should get new" do
    get new_future_project_type_url
    assert_response :success
  end

  test "should create future_project_type" do
    assert_difference('FutureProjectType.count') do
      post future_project_types_url, params: { future_project_type: { abbrev: @future_project_type.abbrev, color: @future_project_type.color, name: @future_project_type.name } }
    end

    assert_redirected_to future_project_type_url(FutureProjectType.last)
  end

  test "should show future_project_type" do
    get future_project_type_url(@future_project_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_future_project_type_url(@future_project_type)
    assert_response :success
  end

  test "should update future_project_type" do
    patch future_project_type_url(@future_project_type), params: { future_project_type: { abbrev: @future_project_type.abbrev, color: @future_project_type.color, name: @future_project_type.name } }
    assert_redirected_to future_project_type_url(@future_project_type)
  end

  test "should destroy future_project_type" do
    assert_difference('FutureProjectType.count', -1) do
      delete future_project_type_url(@future_project_type)
    end

    assert_redirected_to future_project_types_url
  end
end
