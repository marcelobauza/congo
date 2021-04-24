require 'test_helper'

class Flex::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get flex_projects_index_url
    assert_response :success
  end

end
