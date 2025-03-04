require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(email_address: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should not be valid without email address" do
    @user.email_address = nil
    assert_not @user.valid?
  end

  test "should not be valid with invalid email address" do
    @user.email_address = "invalid"
    assert_not @user.valid?
  end

  test "should normalize email address" do
    @user.email_address = " USER@EXAMPLE.COM "
    @user.save
    assert_equal "user@example.com", @user.email_address
  end

  test "should encrypt api token" do
    @user.api_token = "secret_token"
    @user.save!
    assert @user.encrypted_attribute?(:api_token)
    assert_equal "secret_token", @user.api_token
  end

  test "should have many sessions" do
    @user.save
    @user.sessions.create!(user_agent: "TestAgent", ip_address: "127.0.0.1")
    assert_equal 1, @user.sessions.count
  end

  test "should not be valid without password" do
    @user.password = nil
    assert_not @user.valid?
  end

  test "should not be valid if password and password confirmation do not match" do
    @user.password_confirmation = "differentpassword"
    assert_not @user.valid?
  end
end
