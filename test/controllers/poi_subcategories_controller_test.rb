require 'test_helper'

class PoiSubcategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @poi_subcategory = poi_subcategories(:one)
  end

  test "should get index" do
    get poi_subcategories_url
    assert_response :success
  end

  test "should get new" do
    get new_poi_subcategory_url
    assert_response :success
  end

  test "should create poi_subcategory" do
    assert_difference('PoiSubcategory.count') do
      post poi_subcategories_url, params: { poi_subcategory: { name: @poi_subcategory.name } }
    end

    assert_redirected_to poi_subcategory_url(PoiSubcategory.last)
  end

  test "should show poi_subcategory" do
    get poi_subcategory_url(@poi_subcategory)
    assert_response :success
  end

  test "should get edit" do
    get edit_poi_subcategory_url(@poi_subcategory)
    assert_response :success
  end

  test "should update poi_subcategory" do
    patch poi_subcategory_url(@poi_subcategory), params: { poi_subcategory: { name: @poi_subcategory.name } }
    assert_redirected_to poi_subcategory_url(@poi_subcategory)
  end

  test "should destroy poi_subcategory" do
    assert_difference('PoiSubcategory.count', -1) do
      delete poi_subcategory_url(@poi_subcategory)
    end

    assert_redirected_to poi_subcategories_url
  end
end
