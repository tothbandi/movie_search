require "test_helper"

class MovieSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    log_in_as(@user)
  end

  test "should get new" do
    get new_movie_search_url
    assert_response :success
  end

  test "should get index" do
    get movie_searches_url, params: { keywords: "test", page: 1 }
    assert_response :success
  end
end