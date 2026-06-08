# frozen_string_literal: true

module Types
  class RuntimeStatusType < Types::BaseObject
    description 'A runtime status information entry'

    authorize :read_runtime

    field :last_heartbeat, Types::TimeType,
          null: true,
          description: 'The timestamp of the last heartbeat received from the runtime'
    field :status, Types::RuntimeStatusStatusEnum,
          null: false,
          description: 'The current status of the runtime',
          method: :current_status
    field :uptime, Float,
          null: false,
          description: 'Current uptime percentage for the runtime'
    field :uptimes, [Float],
          null: false,
          description: 'Uptime percentages for the last 14 days'

    id_field RuntimeStatus
    timestamps
  end
end
