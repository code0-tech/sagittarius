# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeUsageUpdaetService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :current_runtime, :usages

      def initialize(current_runtime, usages)
        @current_runtime = current_runtime
        @usages = usages
      end

      def execute
        transactional do |t|
          week_start = Time.zone.today.beginning_of_week(:monday)
          week_end = week_start + 6.days

          db_usage = create_or_find_by!(user: user, week_start: week_start) do |weekly_count|
            weekly_count.week_end = week_end
            weekly_count.value_count = 0
          end

          db_usage.with_lock do
            record.value_count += amount.to_d
            record.week_end ||= week_end
            next if record.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to runtime usage',
              error_code: :invalid_runtime_usage,
              details: db_usage.errors
            )
          end
        end
      end
    end
  end
end
