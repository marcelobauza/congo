require 'test_helper'

class DensityTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @density_type = density_types(:one)
  end

  test "should get index" do
    get density_types_url
    assert_response :success
  end

  test "should get new" do
    get new_density_type_url
    assert_response :success
  end

  test "should create density_type" do
    assert_difference('DensityType.count') do
      post density_types_url, params: { density_type: { color: @density_type.color, identifier: @density_type.identifier, name: @density_type.name, position: @density_type.position } }
    end

    assert_redirected_to density_type_url(DensityType.last)
  end

  test "should show density_type" do
    get density_type_url(@density_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_density_type_url(@density_type)
    assert_response :success
  end

  test "should update density_type" do
    patch density_type_url(@density_type), params: { density_type: { color: @density_type.color, identifier: @density_type.identifier, name: @density_type.name, position: @density_type.position } }
    assert_redirected_to density_type_url(@density_type)
  end

  test "should destroy density_type" do
    assert_difference('DensityType.count', -1) do
      delete density_type_url(@density_type)
    end

    assert_redirected_to density_types_url
  end
end
