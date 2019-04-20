require 'test_helper'

class PropertyTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @property_type = property_types(:one)
  end

  test "should get index" do
    get property_types_url
    assert_response :success
  end

  test "should get new" do
    get new_property_type_url
    assert_response :success
  end

  test "should create property_type" do
    assert_difference('PropertyType.count') do
      post property_types_url, params: { property_type: { description: @property_type.description, name: @property_type.name } }
    end

    assert_redirected_to property_type_url(PropertyType.last)
  end

  test "should show property_type" do
    get property_type_url(@property_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_property_type_url(@property_type)
    assert_response :success
  end

  test "should update property_type" do
    patch property_type_url(@property_type), params: { property_type: { description: @property_type.description, name: @property_type.name } }
    assert_redirected_to property_type_url(@property_type)
  end

  test "should destroy property_type" do
    assert_difference('PropertyType.count', -1) do
      delete property_type_url(@property_type)
    end

    assert_redirected_to property_types_url
  end
end
