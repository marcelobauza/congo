require 'test_helper'

class SurveyorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @surveyor = surveyors(:one)
  end

  test "should get index" do
    get surveyors_url
    assert_response :success
  end

  test "should get new" do
    get new_surveyor_url
    assert_response :success
  end

  test "should create surveyor" do
    assert_difference('Surveyor.count') do
      post surveyors_url, params: { surveyor: { name: @surveyor.name } }
    end

    assert_redirected_to surveyor_url(Surveyor.last)
  end

  test "should show surveyor" do
    get surveyor_url(@surveyor)
    assert_response :success
  end

  test "should get edit" do
    get edit_surveyor_url(@surveyor)
    assert_response :success
  end

  test "should update surveyor" do
    patch surveyor_url(@surveyor), params: { surveyor: { name: @surveyor.name } }
    assert_redirected_to surveyor_url(@surveyor)
  end

  test "should destroy surveyor" do
    assert_difference('Surveyor.count', -1) do
      delete surveyor_url(@surveyor)
    end

    assert_redirected_to surveyors_url
  end
end
