require "test_helper"

class DaysControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get days_new_url
    assert_response :success
  end

  test "should get record" do
    get days_record_url
    assert_response :success
  end
end
