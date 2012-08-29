require 'test_helper'

class Admin::DataoutputControllerTest < ActionController::TestCase
  test "should get reviews" do
    get :reviews
    assert_response :success
  end

end
