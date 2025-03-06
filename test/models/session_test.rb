require "test_helper"

class SessionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @session = @user.sessions.create!(user_agent: "TestAgent", ip_address: "127.0.0.1")
  end

  test "should belong to user" do
    assert_equal @user, @session.user
  end

  test "should have user agent and ip address" do
    assert_equal "TestAgent", @session.user_agent
    assert_equal "127.0.0.1", @session.ip_address
  end
end
