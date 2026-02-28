# frozen_string_literal: true

module Types
  class RuntimeStatusTypeEnum < Types::BaseEnum
    description 'The type of runtime status'

    value :ADAPTER, 'Indicates that the runtime status is related to an adapter.', value: 'adapter'
    value :EXECUTION, 'Indicates that the runtime status is related to an execution.', value: 'execution'
  end
end
