# frozen_string_literal: true

module Types
  class ActionStatusType < Types::BaseObject
    description 'An action status information entry'

    authorize :read_runtime

    field :configurations, Types::RuntimeStatusConfigurationType.connection_type,
          null: false,
          description: 'The detailed configuration entries for this action status',
          method: :action_status_configurations
    field :identifier, String,
          null: false,
          description: 'The unique identifier for this action status'
    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current action status'
    field :type, Types::RuntimeStatusTypeEnum,
          null: false,
          description: 'The type of runtime status information'

    def type
      :action
    end

    id_field ActionStatus
    timestamps
  end
end
