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
          runtime.last_heartbeat = Time.zone.now

          unless runtime.save
            t.rollback_and_return ServiceResponse.error(
              message: 'Failed to update runtime heartbeat',
              error_code: :invalid_runtime,
              details: runtime.errors
            )
          end

          db_status = status_relation.find_or_initialize_by(identifier: status_info.identifier)

          db_status.last_heartbeat = Time.zone.at(status_info.timestamp.to_i / 1000.0)
          db_status.status = status_info.status.downcase

          unless db_status.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save runtime status',
              error_code: :invalid_runtime_status,
              details: db_status.errors
            )
          end

          update_configurations(db_status, t)

          return ServiceResponse.success(message: 'Updated runtime status')
        end
      end

      private

      def status_relation
        case status_info
        when Tucana::Shared::AdapterRuntimeStatus
          runtime.adapter_runtime_statuses
        when Tucana::Shared::ExecutionRuntimeStatus
          runtime.execution_runtime_statuses
        when Tucana::Shared::ActionStatus
          runtime.action_statuses
        end
      end

      def update_configurations(db_status, t)
        case status_info
        when Tucana::Shared::AdapterRuntimeStatus
          update_configuration_records(db_status.adapter_status_configurations, t)
        when Tucana::Shared::ActionStatus
          update_configuration_records(db_status.action_status_configurations, t)
        end
      end

      def update_configuration_records(relation, t)
        db_configs = relation.to_a

        status_info.configurations.each_with_index do |config, index|
          db_configs[index] ||= relation.build

          db_configs[index].endpoint = config.endpoint
          db_configs[index].flow_type_identifiers = config.flow_type_identifiers.to_a

          next if db_configs[index].save

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save runtime status configuration',
            error_code: :invalid_runtime_status_configuration,
            details: db_configs[index].errors
          )
        end

        db_configs.drop(status_info.configurations.size).each(&:destroy)
      end
    end
  end
end
