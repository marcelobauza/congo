require 'test_helper'

class UserPolygonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_polygon = user_polygons(:one)
  end

  test "should get index" do
    get user_polygons_url
    assert_response :success
  end

  test "should get new" do
    get new_user_polygon_url
    assert_response :success
  end

  test "should create user_polygon" do
    assert_difference('UserPolygon.count') do
      post user_polygons_url, params: { user_polygon: { layertype: @user_polygon.layertype, text: @user_polygon.text, user_id: @user_polygon.user_id, wkt: @user_polygon.wkt } }
    end

    assert_redirected_to user_polygon_url(UserPolygon.last)
  end

  test "should show user_polygon" do
    get user_polygon_url(@user_polygon)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_polygon_url(@user_polygon)
    assert_response :success
  end

  test "should update user_polygon" do
    patch user_polygon_url(@user_polygon), params: { user_polygon: { layertype: @user_polygon.layertype, text: @user_polygon.text, user_id: @user_polygon.user_id, wkt: @user_polygon.wkt } }
    assert_redirected_to user_polygon_url(@user_polygon)
  end

  test "should destroy user_polygon" do
    assert_difference('UserPolygon.count', -1) do
      delete user_polygon_url(@user_polygon)
    end

    assert_redirected_to user_polygons_url
  end
end
