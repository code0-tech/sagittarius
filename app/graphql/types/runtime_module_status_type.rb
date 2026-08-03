# frozen_string_literal: true

module Types
  class RuntimeModuleStatusType < Types::BaseObject
    description 'Detailed status information for a runtime module'

    authorize :read_runtime_module

    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime module'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current status of the runtime module'
    field :uptimes, [Float, { null: false }],
          null: false,
          description: 'Uptime percentage for each of the last 14 days, index 0 is today',
          method: :uptime_percentages

    id_field RuntimeModuleStatus
    timestamps
  end
end
