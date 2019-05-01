require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_url, params: { project: { 0: @project.0, DEFAULT: @project.DEFAULT, address: @project.address, agency_id: @project.agency_id, build_date: @project.build_date, code: @project.code, county_id: @project.county_id, elevators: @project.elevators, floors: @project.floors, general_observation: @project.general_observation, integer: @project.integer, name: @project.name, pilot_opening_date: @project.pilot_opening_date, project_type_id: @project.project_type_id, quantity_department_for_floor: @project.quantity_department_for_floor, sale_date: @project.sale_date, the_geom: @project.the_geom, transfer_date: @project.transfer_date } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { 0: @project.0, DEFAULT: @project.DEFAULT, address: @project.address, agency_id: @project.agency_id, build_date: @project.build_date, code: @project.code, county_id: @project.county_id, elevators: @project.elevators, floors: @project.floors, general_observation: @project.general_observation, integer: @project.integer, name: @project.name, pilot_opening_date: @project.pilot_opening_date, project_type_id: @project.project_type_id, quantity_department_for_floor: @project.quantity_department_for_floor, sale_date: @project.sale_date, the_geom: @project.the_geom, transfer_date: @project.transfer_date } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
