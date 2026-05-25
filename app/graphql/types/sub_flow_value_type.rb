# frozen_string_literal: true

module Types
  class SubFlowValueType < Types::BaseObject
    description 'Represents a sub-flow parameter value.'

    field :function_definition, Types::FunctionDefinitionType,
          null: true,
          description: 'The resolved function definition to execute.'
    field :settings, [Types::SubFlowValueSettingType],
          method: :sub_flow_settings,
          null: false,
          description: 'The sub-flow settings.'
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
