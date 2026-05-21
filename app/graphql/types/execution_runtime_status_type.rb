# frozen_string_literal: true

module Types
  class ExecutionRuntimeStatusType < Types::BaseObject
    description 'An execution runtime status information entry'

    authorize :read_runtime

    field :identifier, String,
          null: false,
          description: 'The unique identifier for this execution status'
    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current execution status'
    field :type, Types::RuntimeStatusTypeEnum,
          null: false,
          description: 'The type of runtime status information'

    def type
      :execution
    end

    id_field ExecutionRuntimeStatus
    timestamps
  end
end
