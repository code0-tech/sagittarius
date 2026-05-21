# frozen_string_literal: true

module Types
  class RuntimeStatusConfigurationType < Types::BaseUnion
    description 'Detailed configuration about a runtime status, either: endpoint, ...'

    possible_types Types::ActionStatusConfigurationEndpointType, Types::AdapterStatusConfigurationEndpointType

    def self.resolve_type(object, _context)
      return Types::AdapterStatusConfigurationEndpointType if object.is_a?(AdapterStatusConfiguration)
      return Types::ActionStatusConfigurationEndpointType if object.is_a?(ActionStatusConfiguration)

      raise "Unknown RuntimeStatusInformation type: #{object.class.name}"
    end
  end
end
