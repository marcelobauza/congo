require 'test_helper'

class BuildingRegulationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @building_regulation = building_regulations(:one)
  end

  test "should get index" do
    get building_regulations_url
    assert_response :success
  end

  test "should get new" do
    get new_building_regulation_url
    assert_response :success
  end

  test "should create building_regulation" do
    assert_difference('BuildingRegulation.count') do
      post building_regulations_url, params: { building_regulation: { am_cc: @building_regulation.am_cc, aminciti: @building_regulation.aminciti, building_zone: @building_regulation.building_zone, comments: @building_regulation.comments, construct: @building_regulation.construct, county_id: @building_regulation.county_id, density_type_id: @building_regulation.density_type_id, grouping: @building_regulation.grouping, hectarea_inhabitants: @building_regulation.hectarea_inhabitants, icinciti: @building_regulation.icinciti, identifier: @building_regulation.identifier, land_ocupation: @building_regulation.land_ocupation, osinciti: @building_regulation.osinciti, parkings: @building_regulation.parkings, site: @building_regulation.site, the_geom: @building_regulation.the_geom } }
    end

    assert_redirected_to building_regulation_url(BuildingRegulation.last)
  end

  test "should show building_regulation" do
    get building_regulation_url(@building_regulation)
    assert_response :success
  end

  test "should get edit" do
    get edit_building_regulation_url(@building_regulation)
    assert_response :success
  end

  test "should update building_regulation" do
    patch building_regulation_url(@building_regulation), params: { building_regulation: { am_cc: @building_regulation.am_cc, aminciti: @building_regulation.aminciti, building_zone: @building_regulation.building_zone, comments: @building_regulation.comments, construct: @building_regulation.construct, county_id: @building_regulation.county_id, density_type_id: @building_regulation.density_type_id, grouping: @building_regulation.grouping, hectarea_inhabitants: @building_regulation.hectarea_inhabitants, icinciti: @building_regulation.icinciti, identifier: @building_regulation.identifier, land_ocupation: @building_regulation.land_ocupation, osinciti: @building_regulation.osinciti, parkings: @building_regulation.parkings, site: @building_regulation.site, the_geom: @building_regulation.the_geom } }
    assert_redirected_to building_regulation_url(@building_regulation)
  end

  test "should destroy building_regulation" do
    assert_difference('BuildingRegulation.count', -1) do
      delete building_regulation_url(@building_regulation)
    end

    assert_redirected_to building_regulations_url
  end
end
