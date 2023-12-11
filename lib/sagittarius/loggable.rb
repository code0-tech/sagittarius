# frozen_string_literal: true

module Sagittarius
  module Loggable
    extend ActiveSupport::Concern

    class_methods do
      def logger
        Logger.new(Rails.logger, name || '<Anonymous>')
      end
    end

    def logger
      Logger.new(Rails.logger, self.class.name || '<Anonymous>')
    end

    class Logger
      def initialize(log, clazz)
        @log = log
        @clazz = clazz
      end

      delegate :debug?, :info?, :warn?, :error?, :fatal?, :formatter, :level, to: :@log

      def with_context(&block)
        Context.with_context(class: @clazz, &block)
      end

      def debug(message)
        with_context { @log.debug(message) }
      end

      def error(message)
        with_context { @log.error(message) }
      end

      def warn(message)
        with_context { @log.warn(message) }
      end

      def info(message)
        with_context { @log.info(message) }
      end
    end
  end
end
