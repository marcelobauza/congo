require 'test_helper'

class Admin::FutureProjectSubTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_future_project_sub_type = admin_future_project_sub_types(:one)
  end

  test "should get index" do
    get admin_future_project_sub_types_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_future_project_sub_type_url
    assert_response :success
  end

  test "should create admin_future_project_sub_type" do
    assert_difference('Admin::FutureProjectSubType.count') do
      post admin_future_project_sub_types_url, params: { admin_future_project_sub_type: { name: @admin_future_project_sub_type.name } }
    end

    assert_redirected_to admin_future_project_sub_type_url(Admin::FutureProjectSubType.last)
  end

  test "should show admin_future_project_sub_type" do
    get admin_future_project_sub_type_url(@admin_future_project_sub_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_future_project_sub_type_url(@admin_future_project_sub_type)
    assert_response :success
  end

  test "should update admin_future_project_sub_type" do
    patch admin_future_project_sub_type_url(@admin_future_project_sub_type), params: { admin_future_project_sub_type: { name: @admin_future_project_sub_type.name } }
    assert_redirected_to admin_future_project_sub_type_url(@admin_future_project_sub_type)
  end

  test "should destroy admin_future_project_sub_type" do
    assert_difference('Admin::FutureProjectSubType.count', -1) do
      delete admin_future_project_sub_type_url(@admin_future_project_sub_type)
    end

    assert_redirected_to admin_future_project_sub_types_url
  end
end
