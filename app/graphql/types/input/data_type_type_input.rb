# frozen_string_literal: true

module Types
  module Input
    class DataTypeTypeInput < Types::BaseInputObject
      description 'Represents a DataType'

      argument :identifier, String, required: true, description: 'The identifier scoped to the namespace'
      argument :namespace_id, Types::GlobalIdType[::Namespace], required: true,
            description: 'The namespace where this datatype belongs to'
      argument :variant, Types::DataTypeVariantEnum, required: true, description: 'The type of the datatype'

      argument :generic_keys, [String], required: false, description: 'The generic keys for the datatype'

      argument :rules, [Rules::DataTypeRuleInputType], required: false, description: 'The rules for the datatype'

      argument :parent_type_identifier, String, required: false,
               description: 'The identifier of the parent data type, if any'

    end
  end
end
