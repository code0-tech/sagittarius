# frozen_string_literal: true

module Types
  module Input
    class DataTypeRuleConfigInputType < Types::BaseInputObject
      description 'Input type for the config of a data type rule'

      # contains key
      # contains type
      # return type
      # parent type
      argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType,
               required: false,
               description: 'Data type identifier'

      # contains key
      argument :key, String,
               required: false,
               description: 'The key of the rule'

      # number range
      argument :from, Integer,
               required: false,
               description: 'The minimum value of the range'
      argument :steps, Integer,
               required: false,
               description: 'The step value for the range, if applicable'
      argument :to, Integer,
               required: false,
               description: 'The maximum value of the range'

      # item of collection
      argument :items, [GraphQL::Types::JSON],
               required: false,
               description: 'The items of the rule'

      # regex
      argument :pattern, String,
               required: false,
               description: 'The regex pattern to match against the data type value.'

      # input types
      argument :input_types, [Types::Input::DataTypeRuleInputTypeConfigInputType],
               required: false,
               description: 'The input types that can be used in this data type rule'
    end
  end
end
