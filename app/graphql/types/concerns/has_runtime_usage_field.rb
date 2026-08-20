# frozen_string_literal: true

module Types
  module Concerns
    module HasRuntimeUsageField
      extend ActiveSupport::Concern

      # The allowed after_date..before_date span, bounded per aggregation level, per the
      # product decision that days can be queried 7-31 days back, weeks 2-26 weeks back, and
      # months 2-24 months back.
      ALLOWED_SPAN = {
        'day' => (7..31),
        'week' => (2..26),
        'month' => (2..24),
      }.freeze

      class_methods do
        # relation: proc taking the resolved object and returning its runtime_usage_daily_
        # aggregates scope. Defaults to the association of the same name, which every owner
        # type has.
        # authorized: proc taking the resolved object and returning whether usage may be
        # read; runs in the resolver instance's context (via instance_exec), so it can call
        # instance methods like current_authentication. Defaults to always-authorized, since
        # every current runtime_usage_field caller already gates the whole type with
        # `authorize`.
        def runtime_usage_field(description:, relation: ->(object) { object.runtime_usage_daily_aggregates },
                                authorized: ->(_object) { true }, null: false)
          field :runtime_usage, [Types::RuntimeUsageBucketType], null: null, description: description do
            argument :aggregation, Types::RuntimeUsageAggregationEnum, required: false, default_value: 'day',
                                                                       description: 'Granularity to bucket usage into'
            argument :after_date, GraphQL::Types::ISO8601Date, required: true,
                                                               description: 'Start of the usage range (inclusive)'
            argument :before_date, GraphQL::Types::ISO8601Date, required: true,
                                                                description: 'End of the usage range (inclusive)'
          end

          define_method(:runtime_usage) do |aggregation:, after_date:, before_date:|
            next nil unless instance_exec(object, &authorized)

            HasRuntimeUsageField.validate_range!(aggregation: aggregation, after_date: after_date,
                                                 before_date: before_date)

            RuntimeUsageDailyAggregatesFinder.new(
              relation: relation.call(object),
              aggregation: aggregation,
              after_date: after_date,
              before_date: before_date
            ).execute
          end
        end
      end

      def self.validate_range!(aggregation:, after_date:, before_date:)
        raise GraphQL::ExecutionError, 'after_date must not be later than before_date' if after_date > before_date

        allowed_span = ALLOWED_SPAN.fetch(aggregation)
        span = span_for(aggregation, after_date, before_date)
        return if allowed_span.cover?(span)

        raise GraphQL::ExecutionError,
              "Date range for #{aggregation} aggregation must span between " \
              "#{allowed_span.min} and #{allowed_span.max} #{aggregation}s, got #{span}"
      end

      def self.span_for(aggregation, after_date, before_date)
        case aggregation
        when 'day' then (before_date - after_date).to_i + 1
        when 'week' then weeks_between(after_date, before_date) + 1
        when 'month' then months_between(after_date, before_date) + 1
        end
      end

      # Counts distinct ISO weeks (Monday-start), matching date_trunc('week', ...) bucketing.
      def self.weeks_between(from, to)
        (to.beginning_of_week - from.beginning_of_week).to_i / 7
      end

      def self.months_between(from, to)
        ((to.year * 12) + to.month) - ((from.year * 12) + from.month)
      end

      private_class_method :span_for, :weeks_between, :months_between
    end
  end
end
