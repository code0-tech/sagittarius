# frozen_string_literal: true

module Sagittarius
  module Logs
    class JsonFormatter < ::Logger::Formatter
      def call(severity, datetime, _progname, message)
        JSON.generate(data(severity, datetime, message)) << "\n"
      end

      def data(severity, datetime, message)
        data = {}
        data[:severity] = severity
        data[:time] = datetime.utc.iso8601(3)

        case message
        when String
          data[:message] = chomp message
        when Hash
          data.merge!(message)
        end

        data.merge!(Code0::ZeroTrack::Context.current.to_h)
      end

      def chomp(message)
        message.chomp! until message.chomp == message

        message.strip
      end

      class Tagged < JsonFormatter
        include ActiveSupport::TaggedLogging::Formatter

        def tagged(*_args)
          yield self # Ignore tags, they break the json layout as they are prepended to the log line
        end
      end
    end
  end
end
