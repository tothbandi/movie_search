require "uri"
require "net/http"
require "logger"

##
# This class responsible to process movies list
class MoviesClient
  class << self
    def search(keywords, page = 1)
      cached = true
      response = Rails.cache.fetch("#{keywords} page:#{page}", expires_in: 2.minutes) do
        cached = false
        get_movies(keywords, page)
      end
      { response: response, counter: counter(keywords, page, cached),  cached: cached }
    end

    private

    def counter(keywords, page, cached)
      count = Rails.cache.read("#{keywords} page:#{page} counter") || -1
      count = -1 unless cached
      count = count + 1
      Rails.cache.write("#{keywords} page:#{page} counter", count)
      count
    end

    def get_movies(keywords, page)
      uri = URI(MOVIE_URL)

      params = { query: keywords }
      params[:page] = page if page
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request["accept"] = "application/json"
      request["Authorization"] = "Bearer #{Current.user.api_token}"

      http_logger.info "GET #{ uri }"
      begin
        response = http.request(request)
        http_logger.info "#{ response.code } #{ response.message }"
        response
      rescue => exception
        http_logger.error exception.message
      end
    end

    def http_logger
      @http_logger ||= Logger.new("#{Rails.root}/log/http_logger.log")
    end
  end
end
