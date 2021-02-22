require 'test_helper'

class RentIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboards" do
    log_in

    get rent_indicators_dashboards_path
    assert_response :success
  end
end
