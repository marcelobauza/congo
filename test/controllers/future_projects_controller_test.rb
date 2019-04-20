require 'test_helper'

class FutureProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @future_project = future_projects(:one)
  end

  test "should get index" do
    get future_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_future_project_url
    assert_response :success
  end

  test "should create future_project" do
    assert_difference('FutureProject.count') do
      post future_projects_url, params: { future_project: { active: @future_project.active, address: @future_project.address, architect: @future_project.architect, bimester: @future_project.bimester, cadastral_date: @future_project.cadastral_date, cadastre: @future_project.cadastre, code: @future_project.code, comments: @future_project.comments, county_id: @future_project.county_id, file_data: @future_project.file_data, file_number: @future_project.file_number, floors: @future_project.floors, future_project_type_id: @future_project.future_project_type_id, legal_agent: @future_project.legal_agent, m2_approved: @future_project.m2_approved, m2_built: @future_project.m2_built, m2_field: @future_project.m2_field, name: @future_project.name, owner: @future_project.owner, project_type_id: @future_project.project_type_id, role_number: @future_project.role_number, t_ofi: @future_project.t_ofi, the_geom: @future_project.the_geom, total_commercials: @future_project.total_commercials, total_parking: @future_project.total_parking, total_units: @future_project.total_units, undergrounds: @future_project.undergrounds, year: @future_project.year } }
    end

    assert_redirected_to future_project_url(FutureProject.last)
  end

  test "should show future_project" do
    get future_project_url(@future_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_future_project_url(@future_project)
    assert_response :success
  end

  test "should update future_project" do
    patch future_project_url(@future_project), params: { future_project: { active: @future_project.active, address: @future_project.address, architect: @future_project.architect, bimester: @future_project.bimester, cadastral_date: @future_project.cadastral_date, cadastre: @future_project.cadastre, code: @future_project.code, comments: @future_project.comments, county_id: @future_project.county_id, file_data: @future_project.file_data, file_number: @future_project.file_number, floors: @future_project.floors, future_project_type_id: @future_project.future_project_type_id, legal_agent: @future_project.legal_agent, m2_approved: @future_project.m2_approved, m2_built: @future_project.m2_built, m2_field: @future_project.m2_field, name: @future_project.name, owner: @future_project.owner, project_type_id: @future_project.project_type_id, role_number: @future_project.role_number, t_ofi: @future_project.t_ofi, the_geom: @future_project.the_geom, total_commercials: @future_project.total_commercials, total_parking: @future_project.total_parking, total_units: @future_project.total_units, undergrounds: @future_project.undergrounds, year: @future_project.year } }
    assert_redirected_to future_project_url(@future_project)
  end

  test "should destroy future_project" do
    assert_difference('FutureProject.count', -1) do
      delete future_project_url(@future_project)
    end

    assert_redirected_to future_projects_url
  end
end
