# frozen_string_literal: true

# Workaround for https://github.com/open-telemetry/opentelemetry-ruby/issues/1649
# Rack delivers HTTP headers as ASCII-8BIT strings. When these contain non-UTF-8
# bytes (e.g. malicious user agents), the OTLP protobuf serializer raises
# Encoding::UndefinedConversionError. This patch sanitizes strings to valid UTF-8
# before they reach protobuf. Remove once the upstream issue is resolved.
module Sagittarius
  module OpenTelemetry
    module EncodingSanitizer
      def self.sanitize(value)
        return value unless value.is_a?(String)
        return value if value.encoding == Encoding::UTF_8 && value.valid_encoding?

        value.encode('UTF-8', invalid: :replace, undef: :replace)
      end

      private

      def as_otlp_any_value(value)
        super(EncodingSanitizer.sanitize(value))
      end
    end
  end
end
