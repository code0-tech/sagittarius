# frozen_string_literal: true

module Types
  class RuntimeModuleStatusType < Types::BaseObject
    description 'A runtime module status information entry'

    authorize :read_runtime_module

    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime module'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current status of the runtime module',
          method: :current_status
    field :uptime, Float,
          null: false,
          description: 'Current uptime percentage for the runtime module'
    field :uptimes, [Float],
          null: false,
          description: 'Uptime percentages for the last 14 days'

    id_field RuntimeModuleStatus
    timestamps
  end
end
