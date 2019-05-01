require 'test_helper'

class ProjectInstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_instance = project_instances(:one)
  end

  test "should get index" do
    get project_instances_url
    assert_response :success
  end

  test "should get new" do
    get new_project_instance_url
    assert_response :success
  end

  test "should create project_instance" do
    assert_difference('ProjectInstance.count') do
      post project_instances_url, params: { project_instance: { DEFAULT: @project_instance.DEFAULT, active: @project_instance.active, bimester: @project_instance.bimester, cadastre: @project_instance.cadastre, comments: @project_instance.comments, false: @project_instance.false, project_id: @project_instance.project_id, project_status_id: @project_instance.project_status_id, true: @project_instance.true, validated: @project_instance.validated, year: @project_instance.year } }
    end

    assert_redirected_to project_instance_url(ProjectInstance.last)
  end

  test "should show project_instance" do
    get project_instance_url(@project_instance)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_instance_url(@project_instance)
    assert_response :success
  end

  test "should update project_instance" do
    patch project_instance_url(@project_instance), params: { project_instance: { DEFAULT: @project_instance.DEFAULT, active: @project_instance.active, bimester: @project_instance.bimester, cadastre: @project_instance.cadastre, comments: @project_instance.comments, false: @project_instance.false, project_id: @project_instance.project_id, project_status_id: @project_instance.project_status_id, true: @project_instance.true, validated: @project_instance.validated, year: @project_instance.year } }
    assert_redirected_to project_instance_url(@project_instance)
  end

  test "should destroy project_instance" do
    assert_difference('ProjectInstance.count', -1) do
      delete project_instance_url(@project_instance)
    end

    assert_redirected_to project_instances_url
  end
end
