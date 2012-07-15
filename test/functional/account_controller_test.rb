require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  test "should get withdraw" do
    get :withdraw
    assert_response :success
  end

end
