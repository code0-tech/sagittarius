# frozen_string_literal: true

module Types
  class RuntimeModuleDefinitionType < Types::BaseObject
    description 'A runtime module definition endpoint'

    authorize :read_runtime_module

    field :endpoint, String, null: false, description: 'Endpoint path of the module definition'
    field :host, String, null: false, description: 'Host of the module definition endpoint'
    field :port, Types::BigIntType, null: false, description: 'Port of the module definition endpoint'

    id_field RuntimeModuleDefinition
    timestamps
  end
end
