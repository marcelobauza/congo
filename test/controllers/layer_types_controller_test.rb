require 'test_helper'

class LayerTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @layer_type = layer_types(:one)
  end

  test "should get index" do
    get layer_types_url
    assert_response :success
  end

  test "should get new" do
    get new_layer_type_url
    assert_response :success
  end

  test "should create layer_type" do
    assert_difference('LayerType.count') do
      post layer_types_url, params: { layer_type: { name: @layer_type.name, title: @layer_type.title } }
    end

    assert_redirected_to layer_type_url(LayerType.last)
  end

  test "should show layer_type" do
    get layer_type_url(@layer_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_layer_type_url(@layer_type)
    assert_response :success
  end

  test "should update layer_type" do
    patch layer_type_url(@layer_type), params: { layer_type: { name: @layer_type.name, title: @layer_type.title } }
    assert_redirected_to layer_type_url(@layer_type)
  end

  test "should destroy layer_type" do
    assert_difference('LayerType.count', -1) do
      delete layer_type_url(@layer_type)
    end

    assert_redirected_to layer_types_url
  end
end
