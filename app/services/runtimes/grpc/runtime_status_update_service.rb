# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeStatusUpdateService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable
      include Runtimes::Grpc::TranslationUpdateHelper

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

          db_status = RuntimeStatus.find_or_initialize_by(runtime: runtime,
                                                          identifier: status_info.identifier)

          db_status.last_heartbeat = Time.zone.at(status_info.timestamp.to_i)
          db_status.status_type = if status_info.is_a?(Tucana::Shared::AdapterRuntimeStatus)
                                    :adapter
                                  else
                                    :execution
                                  end

          db_status.runtime_features.clear

          status_info.features.each do |feature|
            db_feature = db_status.runtime_features.new

            db_feature.names = update_translations(feature.name, db_feature.names)
            db_feature.descriptions = update_translations(feature.description, db_feature.descriptions)

            next if db_feature.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save runtime feature',
              error_code: :invalid_runtime_feature,
              details: db_feature.errors
            )
          end

          db_status.status = status_info.status.downcase

          db_configs = db_status.runtime_status_configurations.first(status_info.configurations.size)

          status_info.configurations.each_with_index do |config, index|
            db_configs[index] ||= db_status.runtime_status_configurations.build

            db_configs[index].endpoint = config.endpoint

            next if db_configs[index].save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save runtime status configuration',
              error_code: :invalid_runtime_status_configuration,
              details: db_configs.errors
            )
          end

          unless db_status.save
            t.rollback_and_return! ServiceResponse.error(
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
