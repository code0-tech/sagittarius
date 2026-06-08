# frozen_string_literal: true

module Types
  class RuntimeStatusType < Types::BaseObject
    description 'A runtime status information entry'

    authorize :read_runtime
    field :configurations, Types::RuntimeStatusConfigurationType.connection_type,
          null: false,
          description: 'The detailed configuration entries for this runtime status (only for adapters)',
          method: :runtime_status_configurations
    field :identifier, String,
          null: false,
          description: 'The unique identifier for this runtime status'
    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current status of the runtime',
          method: :current_status
    field :type, RuntimeStatusTypeEnum,
          null: false,
          description: 'Type of the runtime status',
          method: :status_type

    id_field RuntimeStatus
    timestamps
  end
end
