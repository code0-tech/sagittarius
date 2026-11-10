# frozen_string_literal: true

module Types
  class SubFlowFunctionType < Types::BaseObject
    description 'Identifies the sub-flow function a node executed, mirroring Tucana SubFlowFunction.'

    field :definition_source, String,
          null: true,
          description: 'Source the sub-flow function definition originates from, if any.'
    field :function_identifier, String,
          null: true,
          description: 'Identifier of the sub-flow function.'
  end
end
