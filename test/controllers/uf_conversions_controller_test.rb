require 'test_helper'

class UfConversionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @uf_conversion = uf_conversions(:one)
  end

  test "should get index" do
    get uf_conversions_url
    assert_response :success
  end

  test "should get new" do
    get new_uf_conversion_url
    assert_response :success
  end

  test "should create uf_conversion" do
    assert_difference('UfConversion.count') do
      post uf_conversions_url, params: { uf_conversion: { uf_date: @uf_conversion.uf_date, uf_value: @uf_conversion.uf_value } }
    end

    assert_redirected_to uf_conversion_url(UfConversion.last)
  end

  test "should show uf_conversion" do
    get uf_conversion_url(@uf_conversion)
    assert_response :success
  end

  test "should get edit" do
    get edit_uf_conversion_url(@uf_conversion)
    assert_response :success
  end

  test "should update uf_conversion" do
    patch uf_conversion_url(@uf_conversion), params: { uf_conversion: { uf_date: @uf_conversion.uf_date, uf_value: @uf_conversion.uf_value } }
    assert_redirected_to uf_conversion_url(@uf_conversion)
  end

  test "should destroy uf_conversion" do
    assert_difference('UfConversion.count', -1) do
      delete uf_conversion_url(@uf_conversion)
    end

    assert_redirected_to uf_conversions_url
  end
end
