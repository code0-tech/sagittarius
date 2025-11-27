# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class Logger < Grpc::AllMethodServerInterceptor
        include Code0::ZeroTrack::Loggable

        CODES = %i[OK CANCELLED UNKNOWN INVALID_ARGUMENT DEADLINE_EXCEEDED NOT_FOUND ALREADY_EXISTS PERMISSION_DENIED
                   RESOURCE_EXHAUSTED FAILED_PRECONDITION ABORTED OUT_OF_RANGE UNIMPLEMENTED INTERNAL UNAVAILABLE
                   DATA_LOSS UNAUTHENTICATED].index_by do |code|
          ::GRPC::Core::StatusCodes.const_get(code)
        end

        def execute(method:, **_)
          start_time = Sagittarius::Utils.monotonic_time
          code = ::GRPC::Core::StatusCodes::OK
          exception = nil

          yield
        rescue StandardError => e
          code = if e.is_a?(::GRPC::BadStatus)
                   e.code
                 else
                   ::GRPC::Core::StatusCodes::UNKNOWN
                 end
          exception = e

          raise
        ensure
          end_time = Sagittarius::Utils.monotonic_time
          payload = log_payload(method, code, end_time - start_time, exception)

          if exception
            logger.error(**payload, stack: exception.backtrace)
          else
            logger.info(**payload)
          end
        end

        def log_payload(method, code, duration_s, exception)
          service_name = method.owner.service_name
          found_method, = method.owner
                                .rpc_descs
                                .find { |k, _| ::GRPC::GenericService.underscore(k.to_s) == method.name.to_s }

          method_name = found_method&.to_s || '(unknown)'

          payload = {
            grpc: {
              service: service_name,
              method: method_name,
              code: CODES.fetch(code, code.to_s),
            },
            duration_s: format('%0.10f', duration_s),
          }
          payload.merge!(exception: exception) if exception
          payload
        end
      end
    end
  end
end
