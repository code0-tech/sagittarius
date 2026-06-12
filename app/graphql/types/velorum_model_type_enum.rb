# frozen_string_literal: true

module Types
  class VelorumModelTypeEnum < Types::BaseEnum
    description 'Supported Velorum model capabilities'

    value :UNKNOWN, 'Unknown model capability', value: :UNKNOWN
    value :EXPLAIN, 'Model can explain flows', value: :EXPLAIN
    value :GENERATE, 'Model can generate flows', value: :GENERATE
  end
end
