require 'test_helper'

class RentIndicatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboards" do
    get rent_indicators_dashboards_url
    assert_response :success
  end

end
