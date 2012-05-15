require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get index" do
    user = User.find_by_login("bob_the_trainer")
    if user && user.authenticate("password")
      session[:user_id] = user.id
    end
    get :index
    assert_response :success
  end

end
