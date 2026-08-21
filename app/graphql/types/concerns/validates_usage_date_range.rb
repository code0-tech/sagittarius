# frozen_string_literal: true

module Types
  module Concerns
    # Shared after_date..before_date span validation for usage fields (see
    # HasRuntimeUsageField, HasAiUsageField), per the product decision that days can be
    # queried 7-31 days back, weeks 2-26 weeks back, and months 2-24 months back.
    module ValidatesUsageDateRange
      ALLOWED_SPAN = {
        'day' => (7..31),
        'week' => (2..26),
        'month' => (2..24),
      }.freeze

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
