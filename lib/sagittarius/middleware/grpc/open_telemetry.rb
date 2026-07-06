# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class OpenTelemetry < Grpc::AllMethodServerInterceptor
        def self.tracer
          @tracer ||= ::OpenTelemetry.tracer_provider.tracer('sagittarius-grpc')
        end

        GRPC_CODE_NAMES = %i[OK CANCELLED UNKNOWN INVALID_ARGUMENT DEADLINE_EXCEEDED NOT_FOUND ALREADY_EXISTS
                             PERMISSION_DENIED RESOURCE_EXHAUSTED FAILED_PRECONDITION ABORTED OUT_OF_RANGE
                             UNIMPLEMENTED INTERNAL UNAVAILABLE DATA_LOSS UNAUTHENTICATED].index_by do |code|
          ::GRPC::Core::StatusCodes.const_get(code)
        end

        # gRPC status codes that represent errors per OTel semantic conventions
        GRPC_ERROR_CODES = %i[CANCELLED UNKNOWN DEADLINE_EXCEEDED UNIMPLEMENTED
                              INTERNAL UNAVAILABLE DATA_LOSS].to_set.freeze

        def execute(method:, call:, **_, &block)
          service_name = method.owner.service_name
          found_method, = method.owner
                                .rpc_descs
                                .find { |k, _| ::GRPC::GenericService.underscore(k.to_s) == method.name.to_s }

          method_name = found_method&.to_s || '(unknown)'
          rpc_method = "#{service_name}/#{method_name}"

          links = extract_remote_span_links(call)
          attributes = build_attributes(rpc_method)

          self.class.tracer.in_span(rpc_method, links: links, kind: :server, attributes: attributes) do |span|
            result = block.call
            record_success(span)
            result
          rescue ::GRPC::BadStatus => e
            record_grpc_error(span, e)
            raise
          rescue StandardError => e
            record_exception(span, e)
            raise
          end
        end

        private

        def build_attributes(rpc_method)
          {
            'rpc.system.name' => 'grpc',
            'rpc.method' => rpc_method,
          }
        end

        def record_success(span)
          span.set_attribute('rpc.response.status_code', 'OK')
        end

        def record_grpc_error(span, error)
          code_name = GRPC_CODE_NAMES.fetch(error.code, error.code.to_s).to_s

          span.set_attribute('rpc.response.status_code', code_name)

          return unless GRPC_ERROR_CODES.include?(code_name.to_sym)

          span.set_attribute('error.type', code_name)
          span.status = ::OpenTelemetry::Trace::Status.error(error.message)
        end

        def record_exception(span, error)
          span.set_attribute('rpc.response.status_code', 'UNKNOWN')
          span.set_attribute('error.type', error.class.name)
          span.status = ::OpenTelemetry::Trace::Status.error(error.message)
          span.record_exception(error)
        end

        def extract_remote_span_links(call)
          extracted_context = ::OpenTelemetry.propagation.extract(call.metadata)
          remote_span_context = ::OpenTelemetry::Trace.current_span(extracted_context).context

          return [] unless remote_span_context.valid?

          [::OpenTelemetry::Trace::Link.new(remote_span_context)]
        rescue StandardError
          []
        end
      end
    end
  end
end
