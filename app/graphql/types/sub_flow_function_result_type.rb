# frozen_string_literal: true

module Types
  class SubFlowFunctionResultType < Types::BaseObject
    description 'A sub-flow function result returned by a node execution, mirroring Tucana SubFlowFunctionResult.'

    field :description, String,
          null: true,
          description: 'Description of the sub-flow function.'
    field :function, Types::SubFlowFunctionType,
          null: true,
          description: 'The sub-flow function that was executed.'
    field :input_schema, GraphQL::Types::JSON,
          null: true,
          description: 'JSON schema describing the sub-flow function input.'
    field :name, String,
          null: true,
          description: 'Name of the sub-flow function.'
    field :output_schema, GraphQL::Types::JSON,
          null: true,
          description: 'JSON schema describing the sub-flow function output.'
    field :subflow_identifier, String,
          null: true,
          description: 'Identifier of the sub-flow that produced this result.'
  end
end
