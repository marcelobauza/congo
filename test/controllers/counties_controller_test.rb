require 'test_helper'

class CountiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @county = counties(:one)
  end

  test "should get index" do
    get counties_url
    assert_response :success
  end

  test "should get new" do
    get new_county_url
    assert_response :success
  end

  test "should create county" do
    assert_difference('County.count') do
      post counties_url, params: { county: { code: @county.code, code_sii: @county.code_sii, commercial_project_data: @county.commercial_project_data, demography_data: @county.demography_data, future_project_data: @county.future_project_data, legislation_data: @county.legislation_data, name: @county.name, name_last_project_future: @county.name_last_project_future, sales_project_data: @county.sales_project_data, transaction_data: @county.transaction_data } }
    end

    assert_redirected_to county_url(County.last)
  end

  test "should show county" do
    get county_url(@county)
    assert_response :success
  end

  test "should get edit" do
    get edit_county_url(@county)
    assert_response :success
  end

  test "should update county" do
    patch county_url(@county), params: { county: { code: @county.code, code_sii: @county.code_sii, commercial_project_data: @county.commercial_project_data, demography_data: @county.demography_data, future_project_data: @county.future_project_data, legislation_data: @county.legislation_data, name: @county.name, name_last_project_future: @county.name_last_project_future, sales_project_data: @county.sales_project_data, transaction_data: @county.transaction_data } }
    assert_redirected_to county_url(@county)
  end

  test "should destroy county" do
    assert_difference('County.count', -1) do
      delete county_url(@county)
    end

    assert_redirected_to counties_url
  end
end
