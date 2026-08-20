# frozen_string_literal: true

module Types
  module Concerns
    module HasUsageField
      extend ActiveSupport::Concern

      class_methods do
        # relation: proc taking the resolved object and returning its usage_daily_aggregates
        # scope. Defaults to the association of the same name, which every owner type has.
        # authorized: proc taking the resolved object and returning whether usage may be
        # read; runs in the resolver instance's context (via instance_exec), so it can call
        # instance methods like current_authentication. Defaults to always-authorized, since
        # every current usage_field caller already gates the whole type with `authorize`.
        def usage_field(description:, relation: ->(object) { object.usage_daily_aggregates },
                        authorized: ->(_object) { true }, null: false)
          field :usage, [Types::UsageBucketType], null: null, description: description do
            argument :aggregation, Types::UsageAggregationEnum, required: false, default_value: 'day',
                                                                description: 'Granularity to bucket usage into'
            argument :after_date, GraphQL::Types::ISO8601Date, required: true,
                                                               description: 'Start of the usage range (inclusive)'
            argument :before_date, GraphQL::Types::ISO8601Date, required: true,
                                                                description: 'End of the usage range (inclusive)'
          end

          define_method(:usage) do |aggregation:, after_date:, before_date:|
            next nil unless instance_exec(object, &authorized)

            Usage::FetchService.new(
              relation: relation.call(object),
              aggregation: aggregation,
              after_date: after_date,
              before_date: before_date
            ).execute
          end
        end
      end
    end
  end
end
