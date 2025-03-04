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