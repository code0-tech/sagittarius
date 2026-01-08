# frozen_string_literal: true

module Types
  class RuntimeStatusStatusEnum < Types::BaseEnum
    description 'The enum status of the detailed status'

    value :NOT_RESPONDING, 'The runtime is not responding to heartbeats', value: 'NOT_RESPONDING'
    value :NOT_READY, 'The runtime is not ready to compute stuff', value: 'NOT_READY'
    value :RUNNING, 'The runtime is running and healthy', value: 'RUNNING'
    value :STOPPED, 'The runtime has been stopped', value: 'STOPPED'
  end
end
