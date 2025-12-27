# frozen_string_literal: true

module Types
  class RuntimeStatusConfigurationType < Types::BaseUnion
    description 'Detailed configuration about a runtime status, either: endpoint, ...'

    possible_types Types::RuntimeStatusConfigurationEndpointType

    def self.resolve_type(object, _context)
      return Types::RuntimeStatusConfigurationEndpointType if object.endpoint.present?

      raise "Unknown RuntimeStatusInformation type: #{object.class.name}"
    end
  end
end
