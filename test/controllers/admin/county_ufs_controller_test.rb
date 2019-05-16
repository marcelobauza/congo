require 'test_helper'

class Admin::CountyUfsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_county_uf = admin_county_ufs(:one)
  end

  test "should get index" do
    get admin_county_ufs_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_county_uf_url
    assert_response :success
  end

  test "should create admin_county_uf" do
    assert_difference('Admin::CountyUf.count') do
      post admin_county_ufs_url, params: { admin_county_uf: { county_id: @admin_county_uf.county_id, property_type_id: @admin_county_uf.property_type_id, uf_max: @admin_county_uf.uf_max, uf_min: @admin_county_uf.uf_min } }
    end

    assert_redirected_to admin_county_uf_url(Admin::CountyUf.last)
  end

  test "should show admin_county_uf" do
    get admin_county_uf_url(@admin_county_uf)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_county_uf_url(@admin_county_uf)
    assert_response :success
  end

  test "should update admin_county_uf" do
    patch admin_county_uf_url(@admin_county_uf), params: { admin_county_uf: { county_id: @admin_county_uf.county_id, property_type_id: @admin_county_uf.property_type_id, uf_max: @admin_county_uf.uf_max, uf_min: @admin_county_uf.uf_min } }
    assert_redirected_to admin_county_uf_url(@admin_county_uf)
  end

  test "should destroy admin_county_uf" do
    assert_difference('Admin::CountyUf.count', -1) do
      delete admin_county_uf_url(@admin_county_uf)
    end

    assert_redirected_to admin_county_ufs_url
  end
end
