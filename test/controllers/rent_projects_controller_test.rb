require 'test_helper'

class RentProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rent_project = rent_projects(:one)
  end

  test "should get index" do
    get rent_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_rent_project_url
    assert_response :success
  end

  test "should create rent_project" do
    assert_difference('RentProject.count') do
      post rent_projects_url, params: { rent_project: { bathroom: @rent_project.bathroom, bedroom: @rent_project.bedroom, bimester: @rent_project.bimester, catastral_date: @rent_project.catastral_date, code: @rent_project.code, county_id: @rent_project.county_id, floors: @rent_project.floors, half_bedroom: @rent_project.half_bedroom, name: @rent_project.name, offer: @rent_project.offer, population_per_building: @rent_project.population_per_building, price: @rent_project.price, project_type_id: @rent_project.project_type_id, sale_date: @rent_project.sale_date, square_meters_terrain: @rent_project.square_meters_terrain, surface_util: @rent_project.surface_util, terrace: @rent_project.terrace, the_geom: @rent_project.the_geom, total_beds: @rent_project.total_beds, uf_terrain: @rent_project.uf_terrain, year: @rent_project.year } }
    end

    assert_redirected_to rent_project_url(RentProject.last)
  end

  test "should show rent_project" do
    get rent_project_url(@rent_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_rent_project_url(@rent_project)
    assert_response :success
  end

  test "should update rent_project" do
    patch rent_project_url(@rent_project), params: { rent_project: { bathroom: @rent_project.bathroom, bedroom: @rent_project.bedroom, bimester: @rent_project.bimester, catastral_date: @rent_project.catastral_date, code: @rent_project.code, county_id: @rent_project.county_id, floors: @rent_project.floors, half_bedroom: @rent_project.half_bedroom, name: @rent_project.name, offer: @rent_project.offer, population_per_building: @rent_project.population_per_building, price: @rent_project.price, project_type_id: @rent_project.project_type_id, sale_date: @rent_project.sale_date, square_meters_terrain: @rent_project.square_meters_terrain, surface_util: @rent_project.surface_util, terrace: @rent_project.terrace, the_geom: @rent_project.the_geom, total_beds: @rent_project.total_beds, uf_terrain: @rent_project.uf_terrain, year: @rent_project.year } }
    assert_redirected_to rent_project_url(@rent_project)
  end

  test "should destroy rent_project" do
    assert_difference('RentProject.count', -1) do
      delete rent_project_url(@rent_project)
    end

    assert_redirected_to rent_projects_url
  end
end
