# frozen_string_literal: true

module Types
  class RuntimeStatusEnum < BaseEnum
    description 'Represent all available aquila statuses'

    value :CONNECTED, 'No problem with the connection to aquila', value: :connected
    value :DISCONNECTED, 'The runtime is disconnected, cause unknown', value: :disconnected
  end
end
