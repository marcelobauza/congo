require 'test_helper'

class LandUseTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @land_use_type = land_use_types(:one)
  end

  test "should get index" do
    get land_use_types_url
    assert_response :success
  end

  test "should get new" do
    get new_land_use_type_url
    assert_response :success
  end

  test "should create land_use_type" do
    assert_difference('LandUseType.count') do
      post land_use_types_url, params: { land_use_type: { abbreviation: @land_use_type.abbreviation, identifier: @land_use_type.identifier, name: @land_use_type.name } }
    end

    assert_redirected_to land_use_type_url(LandUseType.last)
  end

  test "should show land_use_type" do
    get land_use_type_url(@land_use_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_land_use_type_url(@land_use_type)
    assert_response :success
  end

  test "should update land_use_type" do
    patch land_use_type_url(@land_use_type), params: { land_use_type: { abbreviation: @land_use_type.abbreviation, identifier: @land_use_type.identifier, name: @land_use_type.name } }
    assert_redirected_to land_use_type_url(@land_use_type)
  end

  test "should destroy land_use_type" do
    assert_difference('LandUseType.count', -1) do
      delete land_use_type_url(@land_use_type)
    end

    assert_redirected_to land_use_types_url
  end
end
