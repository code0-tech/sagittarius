# frozen_string_literal: true

module Types
  class UsageBucketType < Types::BaseObject
    description 'Aggregated execution usage for a single day, week or month bucket'

    field :period_start, GraphQL::Types::ISO8601Date, null: false,
                                                       description: 'Start date of this usage bucket (inclusive)'
    field :period_end, GraphQL::Types::ISO8601Date, null: false,
                                                     description: 'End date of this usage bucket (inclusive)'
    field :execution_count, GraphQL::Types::BigInt, null: false,
                                                     description: 'Number of executions in this bucket'
    field :total_execution_time, Float, null: false,
                                        description: 'Total execution time in this bucket, in seconds'
  end
end
