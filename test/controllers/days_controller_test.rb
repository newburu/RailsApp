require "test_helper"

class DaysControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get days_home_url
    assert_response :success
  end
end
