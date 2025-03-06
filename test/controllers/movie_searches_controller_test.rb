require "test_helper"
require "minitest/mock"
require "ostruct"

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

  test "index should set variables" do
    @return_data = {
      counter: 1,
      cached: true,
      response: OpenStruct.new(
        code: '200',
        body: {
          'page' => 4,
          'results' => [
            {
              'adult' => false,
              'backdrop_path' => '/rMQWqJoqXkeN1mo05gai1krRSLZ.jpg',
              'genre_ids' => [
                27
              ],
              'id' => 541100,
              'original_language' => 'en',
              'original_title' => 'Thriller',
              'overview' => 'Years after a childhood prank goes horribly wrong, a clique of South Central LA teens find themselves terrorized during Homecoming weekend by a killer hell-bent on revenge.',
              'popularity' => 7.012,
              'poster_path' => '/mliD95nVqBijPGQdZ3xcg8Nsagu.jpg',
              'release_date' => '2018-09-23',
              'title' => 'Thriller',
              'video' => false,
              'vote_average' => 4.2,
              'vote_count' => 29
            },
            {
              'adult' => false,
              'backdrop_path' => nil,
              'genre_ids' => [
                9648
              ],
              'id' => 239622,
              'original_language' => 'en',
              'original_title' => 'Thriller',
              'overview' => 'What happens after the curtain falls on the death of Mimi, tragic heroine of Puccini\'s La boheme. In Thriller, Mimi teams up with the opera\'s comic heroine Musetta to investigate her own death.',
              'popularity' => 1.196,
              'poster_path' => '/yylQMslU8YTFTjntAZSHkC4k5Ai.jpg',
              'release_date' => '1979-01-01',
              'title' => 'Thriller',
              'video' => false,
              'vote_average' => 6.1,
              'vote_count' => 8
            }
          ],
          'total_pages' => 4,
          'total_results' => 72
        }.to_json
      )
    }

    MoviesClient.stub(:search, @return_data, ['test', '1']) do
      get movie_searches_url, params: { keywords: "test", page: 1 }
      assert_response :success
      assert_equal "test", assigns(:keywords)
      assert_equal JSON.parse(@return_data[:response].body)['results'], assigns(:movies)
      assert_equal 1, assigns(:count)
      assert assigns(:cached)
      assert_equal 4, assigns(:page)
      assert_equal 4, assigns(:pages)
    end
  end
end
