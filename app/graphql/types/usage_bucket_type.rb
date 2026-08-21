# frozen_string_literal: true

module Types
  class UsageBucketType < Types::BaseObject
    description 'Aggregated usage for a single day, week or month bucket'

    # rubocop:disable GraphQL/ExtractType -- period_start/period_end are the bucket's own
    # range, not a nested concept worth a separate type
    field :period_end, GraphQL::Types::ISO8601Date, null: false,
                                                    description: 'End date of this usage bucket (inclusive)'
    field :period_start, GraphQL::Types::ISO8601Date, null: false,
                                                      description: 'Start date of this usage bucket (inclusive)'
    field :usage, Types::BigIntType, null: false,
                                     description: 'Number of events (e.g. executions, ai generations) in this bucket'
    field :value, Float, null: false,
                         description: 'Aggregated value for this bucket (e.g. execution time in ' \
                                      'microseconds, ai usage in tokens)'
    # rubocop:enable GraphQL/ExtractType
  end
end
