require 'uri'
require 'net/http'

##
# This class responsible to process movies list
class MoviesClient
  class << self
    def search keywords, page = 1
      cached = true
      response = Rails.cache.fetch("#{keywords} page:#{page}", expires_in: 2.minutes) do
        cached = false
        get_movies(keywords, page)
      end
      { response: response, counter: counter(keywords, page, cached),  cached: cached }
    end

    private

    def counter keywords, page, cached
      count = Rails.cache.read("#{keywords} page:#{page} counter") || -1
      count = -1 unless cached
      count = count + 1
      Rails.cache.write("#{keywords} page:#{page} counter", count)
      count
    end

    def get_movies keywords, page
      uri = URI(MOVIE_URL)

      params = { query: keywords }
      params[:page] = page if page
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request['accept'] = 'application/json'
      request['Authorization'] = "Bearer #{Current.user.token}"

      http_logger.info "GET #{ uri.to_s }"
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

  class Logger < ::Logger

    def initialize *arguments
      super
      @formatter ||= Formatter.new
    end

    def error msg, &block
      super if msg
    end

    private

    class Formatter
      # <severity[0]> [<time> #<pid>] <severity> -- <progname>: <message>\n
      LOG_FORMAT  = "%s, [%s #%d] %5s -- %s: %s\n".freeze
      TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%6N'.freeze

      def call severity, time, progname, message
        LOG_FORMAT % [ severity[0],
                       format_time(time),
                       $$,
                       severity,
                       progname,
                       msg2str(message) ]
      end

      private

        def format_time time
          time.strftime(TIME_FORMAT)
        end

        def msg2str(msg)
          case msg
          when ::String
            msg
          when ::Exception
            "#{ msg.message } (#{ msg.class })\n" <<
            (msg.backtrace || []).join("\n")
          else
            msg.inspect
          end
        end
    end
  end
end

