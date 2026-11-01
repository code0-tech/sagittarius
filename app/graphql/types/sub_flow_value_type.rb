# frozen_string_literal: true

module Types
  class SubFlowValueType < Types::BaseObject
    description 'Represents a sub-flow parameter value.'

    field :description, String,
          null: true,
          description: 'The sub-flow description.'
    field :function_definition, Types::FunctionDefinitionType,
          null: true,
          description: 'The resolved function definition to execute.'
    field :name, String,
          null: true,
          description: 'The sub-flow name.'
    field :parameters, [Types::SubFlowValueParameterType],
          method: :sub_flow_parameters,
          null: false,
          description: 'The sub-flow parameters.'
    field :signature, String,
          null: false,
          description: 'The sub-flow signature.'
    field :starting_node_id, GlobalIdType[::NodeFunction],
          null: true,
          description: 'The starting node to execute.'

    def starting_node_id
      object.starting_node&.to_global_id
    end
  end
end
