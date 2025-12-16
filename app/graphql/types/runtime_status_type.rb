# frozen_string_literal: true

module Types
  class RuntimeStatusType < Types::BaseObject
    description 'A runtime status information entry'

    field :configurations, Types::RuntimeStatusConfigurationType.connection_type,
          null: false,
          description: 'The detailed configuration entries for this runtime status (only for adapters)',
          method: :runtime_status_configurations
    field :feature_set, [String], null: false, description: 'The set of features supported by the runtime'
    field :identifier, String, null: false, description: 'The unique identifier for this runtime status'
    field :last_heartbeat, Types::TimeType, null: true,
                                            description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current status of the runtime (e.g. running, stopped)'
    field :type, Types::RuntimeStatusTypeEnum,
          null: false,
          description: 'The type of runtime status information (e.g. adapter, execution)', method: :status_type

    id_field RuntimeStatus
    timestamps
  end
end
