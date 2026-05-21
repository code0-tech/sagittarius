# frozen_string_literal: true

module Types
  class RuntimeStatusType < Types::BaseUnion
    description 'A runtime status information entry'

    possible_types Types::ActionStatusType, Types::AdapterRuntimeStatusType, Types::ExecutionRuntimeStatusType

    def self.resolve_type(object, _context)
      case object
      when ActionStatus
        Types::ActionStatusType
      when AdapterRuntimeStatus
        Types::AdapterRuntimeStatusType
      when ExecutionRuntimeStatus
        Types::ExecutionRuntimeStatusType
      else
        raise "Unknown RuntimeStatus type: #{object.class.name}"
      end
    end
  end
end
