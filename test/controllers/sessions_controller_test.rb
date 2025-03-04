require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_url, params: { email_address: @user.email_address, password: 'password' }
    assert_redirected_to new_movie_search_url
    assert_equal request.user_agent, session[:user_agent]
  end

  test "should not create session with invalid credentials" do
    post session_url, params: { email_address: @user.email_address, password: 'wrongpassword' }
    assert_redirected_to new_session_url
    assert_nil session[:user_id]
    follow_redirect!
    assert_select "div", "Try another email address or password."
  end

  test "should destroy session" do
    log_in_as(@user)
    delete session_url
    assert_redirected_to new_session_url
    assert_nil session[:user_id]
  end
end