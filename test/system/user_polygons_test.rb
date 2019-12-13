require "application_system_test_case"

class UserPolygonsTest < ApplicationSystemTestCase
  setup do
    @user_polygon = user_polygons(:one)
  end

  test "visiting the index" do
    visit user_polygons_url
    assert_selector "h1", text: "User Polygons"
  end

  test "creating a User polygon" do
    visit user_polygons_url
    click_on "New User Polygon"

    fill_in "Layertype", with: @user_polygon.layertype
    fill_in "Text", with: @user_polygon.text
    fill_in "User", with: @user_polygon.user_id
    fill_in "Wkt", with: @user_polygon.wkt
    click_on "Create User polygon"

    assert_text "User polygon was successfully created"
    click_on "Back"
  end

  test "updating a User polygon" do
    visit user_polygons_url
    click_on "Edit", match: :first

    fill_in "Layertype", with: @user_polygon.layertype
    fill_in "Text", with: @user_polygon.text
    fill_in "User", with: @user_polygon.user_id
    fill_in "Wkt", with: @user_polygon.wkt
    click_on "Update User polygon"

    assert_text "User polygon was successfully updated"
    click_on "Back"
  end

  test "destroying a User polygon" do
    visit user_polygons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User polygon was successfully destroyed"
  end
end
