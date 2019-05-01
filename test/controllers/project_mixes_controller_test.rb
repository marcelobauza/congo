require 'test_helper'

class ProjectMixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_mix = project_mixes(:one)
  end

  test "should get index" do
    get project_mixes_url
    assert_response :success
  end

  test "should get new" do
    get new_project_mix_url
    assert_response :success
  end

  test "should create project_mix" do
    assert_difference('ProjectMix.count') do
      post project_mixes_url, params: { project_mix: { bathroom: @project_mix.bathroom, bedroom: @project_mix.bedroom, mix_type: @project_mix.mix_type } }
    end

    assert_redirected_to project_mix_url(ProjectMix.last)
  end

  test "should show project_mix" do
    get project_mix_url(@project_mix)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_mix_url(@project_mix)
    assert_response :success
  end

  test "should update project_mix" do
    patch project_mix_url(@project_mix), params: { project_mix: { bathroom: @project_mix.bathroom, bedroom: @project_mix.bedroom, mix_type: @project_mix.mix_type } }
    assert_redirected_to project_mix_url(@project_mix)
  end

  test "should destroy project_mix" do
    assert_difference('ProjectMix.count', -1) do
      delete project_mix_url(@project_mix)
    end

    assert_redirected_to project_mixes_url
  end
end
