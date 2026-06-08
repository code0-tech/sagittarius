# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeStatusUpdateService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :runtime, :status_info

      def initialize(runtime:, status_info:)
        @runtime = runtime
        @status_info = status_info
      end

      def execute
        transactional do |t|
          heartbeat = Time.zone.at(status_info.timestamp.to_i)
          runtime.last_heartbeat = heartbeat

          unless runtime.save
            t.rollback_and_return ServiceResponse.error(
              message: 'Failed to update runtime heartbeat',
              error_code: :invalid_runtime,
              details: runtime.errors
            )
          end

          db_status = runtime.runtime_status || runtime.build_runtime_status
          db_status.last_heartbeat = heartbeat
          db_status.status = status_info.status.downcase

          unless db_status.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save runtime status',
              error_code: :invalid_runtime_status,
              details: db_status.errors
            )
          end

          module_record = runtime.runtime_modules.find_by(identifier: status_info.identifier)
          if module_record.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Runtime module not found',
              error_code: :runtime_module_not_found
            )
          end

          module_status = module_record.runtime_module_status || module_record.build_runtime_module_status
          module_status.last_heartbeat = heartbeat
          module_status.status = status_info.status.downcase

          unless module_status.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save runtime module status',
              error_code: :invalid_runtime_module_status,
              details: module_status.errors
            )
          end

          return ServiceResponse.success(message: 'Updated runtime status')
        end
      end
    end
  end
end
