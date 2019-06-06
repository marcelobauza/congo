require 'test_helper'

class ProjectInstanceMixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_instance_mix = project_instance_mixes(:one)
  end

  test "should get index" do
    get project_instance_mixes_url
    assert_response :success
  end

  test "should get new" do
    get new_project_instance_mix_url
    assert_response :success
  end

  test "should create project_instance_mix" do
    assert_difference('ProjectInstanceMix.count') do
      #post project_instance_mixes_url, params: { project_instance_mix: { 0: @project_instance_mix.0, DEFAULT: @project_instance_mix.DEFAULT, common_expenses: @project_instance_mix.common_expenses, discount: @project_instance_mix.discount, h_office: @project_instance_mix.h_office, home_type: @project_instance_mix.home_type, living_room: @project_instance_mix.living_room, mix_id: @project_instance_mix.mix_id, mix_m2_built: @project_instance_mix.mix_m2_built, mix_m2_field: @project_instance_mix.mix_m2_field, mix_selling_speed: @project_instance_mix.mix_selling_speed, mix_terrace_square_meters: @project_instance_mix.mix_terrace_square_meters, mix_uf_m2: @project_instance_mix.mix_uf_m2, mix_uf_value: @project_instance_mix.mix_uf_value, mix_usable_square_meters: @project_instance_mix.mix_usable_square_meters, model: @project_instance_mix.model, percentage: @project_instance_mix.percentage, project_instance_id: @project_instance_mix.project_instance_id, service_room: @project_instance_mix.service_room, stock_units: @project_instance_mix.stock_units, t_max: @project_instance_mix.t_max, t_min: @project_instance_mix.t_min, total_units: @project_instance_mix.total_units, uf_cellar: @project_instance_mix.uf_cellar, uf_max: @project_instance_mix.uf_max, uf_min: @project_instance_mix.uf_min, uf_parking: @project_instance_mix.uf_parking, withdrawal_percent: @project_instance_mix.withdrawal_percent } }
    end

    assert_redirected_to project_instance_mix_url(ProjectInstanceMix.last)
  end

  test "should show project_instance_mix" do
    get project_instance_mix_url(@project_instance_mix)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_instance_mix_url(@project_instance_mix)
    assert_response :success
  end

  test "should update project_instance_mix" do
    #patch project_instance_mix_url(@project_instance_mix), params: { project_instance_mix: { 0: @project_instance_mix.0, DEFAULT: @project_instance_mix.DEFAULT, common_expenses: @project_instance_mix.common_expenses, discount: @project_instance_mix.discount, h_office: @project_instance_mix.h_office, home_type: @project_instance_mix.home_type, living_room: @project_instance_mix.living_room, mix_id: @project_instance_mix.mix_id, mix_m2_built: @project_instance_mix.mix_m2_built, mix_m2_field: @project_instance_mix.mix_m2_field, mix_selling_speed: @project_instance_mix.mix_selling_speed, mix_terrace_square_meters: @project_instance_mix.mix_terrace_square_meters, mix_uf_m2: @project_instance_mix.mix_uf_m2, mix_uf_value: @project_instance_mix.mix_uf_value, mix_usable_square_meters: @project_instance_mix.mix_usable_square_meters, model: @project_instance_mix.model, percentage: @project_instance_mix.percentage, project_instance_id: @project_instance_mix.project_instance_id, service_room: @project_instance_mix.service_room, stock_units: @project_instance_mix.stock_units, t_max: @project_instance_mix.t_max, t_min: @project_instance_mix.t_min, total_units: @project_instance_mix.total_units, uf_cellar: @project_instance_mix.uf_cellar, uf_max: @project_instance_mix.uf_max, uf_min: @project_instance_mix.uf_min, uf_parking: @project_instance_mix.uf_parking, withdrawal_percent: @project_instance_mix.withdrawal_percent } }
    assert_redirected_to project_instance_mix_url(@project_instance_mix)
  end

  test "should destroy project_instance_mix" do
    assert_difference('ProjectInstanceMix.count', -1) do
      delete project_instance_mix_url(@project_instance_mix)
    end

    assert_redirected_to project_instance_mixes_url
  end
end
