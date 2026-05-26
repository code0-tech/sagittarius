# frozen_string_literal: true

module Types
  class NodeParameterType < Types::BaseObject
    description 'Represents a Node parameter'

    authorize :read_flow

    field :cast, String, null: true, description: 'The cast applied to the parameter'
    field :parameter_definition, Types::ParameterDefinitionType, null: false,
                                                                 description: 'The definition of the parameter'
    field :value, Types::NodeParameterValueType, null: true, description: 'The value of the parameter'

    def value
      if object.reference_value.present?
        object.reference_value
      elsif object.sub_flow.present?
        object.sub_flow
      else
        object.literal_value
      end
    end

    id_field NodeParameter
    timestamps
  end
end
