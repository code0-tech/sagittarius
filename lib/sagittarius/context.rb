# frozen_string_literal: true

module Sagittarius
  class Context
    LOG_KEY = 'meta'
    CORRELATION_ID_KEY = 'correlation_id'
    RAW_KEYS = [CORRELATION_ID_KEY].freeze

    class << self
      def with_context(attributes = {})
        context = push(attributes)

        begin
          yield(context)
        ensure
          pop(context)
        end
      end

      def push(new_attributes = {})
        new_context = current&.merge(new_attributes) || new(new_attributes)

        contexts.push(new_context)

        new_context
      end

      def pop(context)
        contexts.pop while contexts.include?(context)
      end

      def correlation_id
        current&.correlation_id
      end

      def current
        contexts.last
      end

      def log_key(key)
        key = key.to_s
        return key if RAW_KEYS.include?(key)
        return key if key.start_with?("#{LOG_KEY}.")

        "#{LOG_KEY}.#{key}"
      end

      private

      def contexts
        Thread.current[:labkit_contexts] ||= []
      end
    end

    def initialize(values = {})
      @data = {}

      assign_attributes(values)
    end

    def merge(new_attributes)
      new_context = self.class.new(data.dup)
      new_context.assign_attributes(new_attributes)

      new_context
    end

    def to_h
      expand_data
    end

    def [](key)
      to_h[log_key(key)]
    end

    def correlation_id
      data[CORRELATION_ID_KEY]
    end

    def get_attribute(attribute)
      raw = call_or_value(data[log_key(attribute)])

      call_or_value(raw)
    end

    protected

    def assign_attributes(attributes)
      attributes = attributes.transform_keys(&method(:log_key))

      data.merge!(attributes)

      # Remove keys that had their values set to `nil` in the new attributes
      data.keep_if { |_, value| valid_data?(value) }

      # Assign a correlation if it was missing in the first context or when
      # explicitly removed
      data[CORRELATION_ID_KEY] ||= new_id

      data
    end

    private

    attr_reader :data

    def log_key(key)
      self.class.log_key(key)
    end

    def call_or_value(value)
      value.respond_to?(:call) ? value.call : value
    end

    def expand_data
      data.transform_values do |value|
        value = call_or_value(value)

        value if valid_data?(value)
      end.compact
    end

    def new_id
      SecureRandom.hex
    end

    def valid_data?(value)
      value == false || value.present?
    end
  end
end
