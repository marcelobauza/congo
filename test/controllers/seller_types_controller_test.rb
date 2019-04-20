require 'test_helper'

class SellerTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller_type = seller_types(:one)
  end

  test "should get index" do
    get seller_types_url
    assert_response :success
  end

  test "should get new" do
    get new_seller_type_url
    assert_response :success
  end

  test "should create seller_type" do
    assert_difference('SellerType.count') do
      post seller_types_url, params: { seller_type: { name: @seller_type.name } }
    end

    assert_redirected_to seller_type_url(SellerType.last)
  end

  test "should show seller_type" do
    get seller_type_url(@seller_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_seller_type_url(@seller_type)
    assert_response :success
  end

  test "should update seller_type" do
    patch seller_type_url(@seller_type), params: { seller_type: { name: @seller_type.name } }
    assert_redirected_to seller_type_url(@seller_type)
  end

  test "should destroy seller_type" do
    assert_difference('SellerType.count', -1) do
      delete seller_type_url(@seller_type)
    end

    assert_redirected_to seller_types_url
  end
end
