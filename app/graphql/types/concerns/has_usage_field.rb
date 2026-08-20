# frozen_string_literal: true

module Types
  module Concerns
    module HasUsageField
      extend ActiveSupport::Concern

      class_methods do
        # relation: proc taking the resolved object and returning its usage_daily_aggregates
        # scope. Defaults to the association of the same name, which every owner type has.
        def usage_field(description:, relation: ->(object) { object.usage_daily_aggregates })
          field :usage, [Types::UsageBucketType], null: false, description: description do
            argument :aggregation, Types::UsageAggregationEnum, required: false, default_value: 'day',
                                                                description: 'Granularity to bucket usage into'
            argument :after_date, GraphQL::Types::ISO8601Date, required: true,
                                                               description: 'Start of the usage range (inclusive)'
            argument :before_date, GraphQL::Types::ISO8601Date, required: true,
                                                                description: 'End of the usage range (inclusive)'
          end

          define_method(:usage) do |aggregation:, after_date:, before_date:|
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
