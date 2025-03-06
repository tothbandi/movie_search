require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user with valid attributes" do
    assert_difference("User.count") do
      post users_url, headers: { "User-Agent" => "useragent" }, params: { user: { email_address: "newuser@example.com", password: "password", password_confirmation: "password" } }
    end
    assert_redirected_to new_movie_search_url
    assert_not_nil cookies[:session_id]
    assert_equal request.user_agent, User.last.sessions.last[:user_agent]
  end

  test "should not create user with invalid attributes" do
    assert_no_difference("User.count") do
      post users_url, params: { user: { email_address: "invalid", password: "password", password_confirmation: "mismatch" } }
    end
    assert_response :unprocessable_entity
    assert_select "li", "Password confirmation doesn't match Password"
  end
end
