require 'test_helper'

class CensusSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @census_source = census_sources(:one)
  end

  test "should get index" do
    get census_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_census_source_url
    assert_response :success
  end

  test "should create census_source" do
    assert_difference('CensusSource.count') do
      post census_sources_url, params: { census_source: { name: @census_source.name } }
    end

    assert_redirected_to census_source_url(CensusSource.last)
  end

  test "should show census_source" do
    get census_source_url(@census_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_census_source_url(@census_source)
    assert_response :success
  end

  test "should update census_source" do
    patch census_source_url(@census_source), params: { census_source: { name: @census_source.name } }
    assert_redirected_to census_source_url(@census_source)
  end

  test "should destroy census_source" do
    assert_difference('CensusSource.count', -1) do
      delete census_source_url(@census_source)
    end

    assert_redirected_to census_sources_url
  end
end
