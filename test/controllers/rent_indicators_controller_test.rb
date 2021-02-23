require 'test_helper'

class RentIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboards" do
    log_in

    get rent_indicators_dashboards_path

    assert_response :success
  end

  test "should get summary" do
    log_in

    get rent_indicators_rent_indicators_summary_path,
      as: :json,
      params: {
        id: neighborhoods(:bella_vista).id,
        to_period: 6,
        to_year: 2020
      }

    assert_response :success
    assert_match Mime[:json].to_s, @response.content_type
  end
end
