# frozen_string_literal: true

module Types
  class NodeParameterType < Types::BaseObject
    description 'Represents a Node parameter'

    authorize :read_flow

    field :runtime_parameter, Types::RuntimeParameterDefinitionType, null: false,
                                                                     description: 'The definition of the parameter'
    field :value, Types::NodeParameterValueType, null: true, description: 'The value of the parameter'

    def value
      if object.literal_value.present?
        object.literal_value
      elsif object.reference_value.present?
        object.reference_value
      elsif object.function_value_id.present?
        object.function_value
      end
    end

    id_field NodeParameter
    timestamps
  end
end
