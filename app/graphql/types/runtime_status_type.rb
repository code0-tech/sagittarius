# frozen_string_literal: true

module Types
  class RuntimeStatusType < BaseEnum
    description 'Represent all available types of statuses of a runtime'

    value :CONNECTED, 'No problem with connection, everything works as expected', value: :connected
    value :DISCONNECTED, 'The runtime is disconnected, cause unknown', value: :disconnected
  end
end
