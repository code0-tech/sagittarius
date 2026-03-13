# frozen_string_literal: true

module Types
  module Input
    class DataTypeInputType < Types::BaseInputObject
      description 'Input for creation of a data type'

      argument :aliases, [Types::Input::TranslationInputType],
               required: false,
               description: 'Name of the function'
      argument :display_messages, [Types::Input::TranslationInputType],
               required: false,
               description: 'Display message of the function'
      argument :generic_keys, [String],
               required: false,
               description: 'Generic keys of the datatype'
      argument :identifier, String,
               required: true,
               description: 'The identifier of the datatype'
      argument :name, [Types::Input::TranslationInputType],
               required: true,
               description: 'Names of the flow type setting'
      argument :rules, [Types::Input::DataTypeRuleInputType],
               required: true,
               description: 'Rules of the datatype'
      argument :variant, Types::DataTypeVariantEnum,
               required: true,
               description: 'The type of the datatype'
    end
  end
end
