# frozen_string_literal: true

module Types
  class AdapterRuntimeStatusType < Types::BaseObject
    description 'An adapter runtime status information entry'

    authorize :read_runtime

    field :configurations, Types::RuntimeStatusConfigurationType.connection_type,
          null: false,
          description: 'The detailed configuration entries for this adapter status',
          method: :adapter_status_configurations
    field :identifier, String,
          null: false,
          description: 'The unique identifier for this adapter status'
    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current adapter status'
    field :type, Types::RuntimeStatusTypeEnum,
          null: false,
          description: 'The type of runtime status information'

    def type
      :adapter
    end

    id_field AdapterRuntimeStatus
    timestamps
  end
end
