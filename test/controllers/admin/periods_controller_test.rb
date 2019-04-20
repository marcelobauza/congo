require 'test_helper'

class Admin::PeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_period = admin_periods(:one)
  end

  test "should get index" do
    get admin_periods_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_period_url
    assert_response :success
  end

  test "should create admin_period" do
    assert_difference('Admin::Period.count') do
      post admin_periods_url, params: { admin_period: { active: @admin_period.active, bimester: @admin_period.bimester, year: @admin_period.year } }
    end

    assert_redirected_to admin_period_url(Admin::Period.last)
  end

  test "should show admin_period" do
    get admin_period_url(@admin_period)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_period_url(@admin_period)
    assert_response :success
  end

  test "should update admin_period" do
    patch admin_period_url(@admin_period), params: { admin_period: { active: @admin_period.active, bimester: @admin_period.bimester, year: @admin_period.year } }
    assert_redirected_to admin_period_url(@admin_period)
  end

  test "should destroy admin_period" do
    assert_difference('Admin::Period.count', -1) do
      delete admin_period_url(@admin_period)
    end

    assert_redirected_to admin_periods_url
  end
end
