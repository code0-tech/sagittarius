# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeStatusUpdateService
      include Sagittarius::Database::Transactional

      attr_reader :runtime, :status_info

      def initialize(runtime:, status_info:)
        @runtime = runtime
        @status_info = status_info
      end

      def execute
        transactional do |t|
          runtime.last_heartbeat = Time.zone.now

          unless runtime.save
            t.rollback_and_return ServiceResponse.error(
              message: 'Failed to update runtime heartbeat',
              error_code: :invalid_runtime,
              details: runtime.errors
            )
          end

          db_status = RuntimeStatus.find_or_initialize_by(runtime: current_runtime,
                                                          identifier: status_info.identifier)

          db_status.last_heartbeat = Time.zone.at(status_info.last_heartbeat.seconds)
          db_status.status_type = if status_info.is_a?(Tucana::Shared::AdapterRuntimeStatus)
                                    :adapter
                                  else
                                    :execution
                                  end
          db_status.feature_set = status_info.feature_set.to_a

          case status_info.status
          when Tucana::Shared::Status::NOT_RESPONDING
            db_status.status = :not_responding
          when Tucana::Shared::Status::NOT_READY
            db_status.status = :not_ready
          when Tucana::Shared::Status::RUNNING
            db_status.status = :running
          when Tucana::Shared::Status::STOPPED
            db_status.status = :stopped
          else
            logger.error("Unknown status received: #{status_info.status}")
            t.rollback_and_return ServiceResponse.error(
              message: 'Unknown status received',
              error_code: :invalid_runtime_status,
              details: { status: status_info.status }
            )
          end

          db_configs = db_status.runtime_status_configurations.first(status_info.configurations.size)

          status_info.configurations.each_with_index do |config, index|
            db_configs[index] ||= db_status.runtime_status_configurations.build

            db_configs[index].endpoint = config.endpoint
          end

          unless db_status.save
            t.rollback_and_return ServiceResponse.error(
              message: 'Failed to save runtime status',
              error_code: :invalid_runtime_status,
              details: db_status.errors
            )
          end

          return ServiceResponse.success(
            message: 'Updated runtime status'
          )
        end
      end
    end
  end
end
