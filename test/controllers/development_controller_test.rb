require "test_helper"

class DevelopmentControllerTest < ActionController::TestCase
  test "shows inde page" do
    get :index
    assert_response :ok
    assert response.body.include?("This page is intended to be shown in development and on Heroku review apps.")
  end
end
