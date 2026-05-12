# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeUsageUpdateService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :usages

      def initialize(usages:)
        @usages = usages
      end

      def execute
        transactional do |t|
          updated_usages = []

          Array.wrap(usages).each do |usage|
            result = update_usage(usage)
            t.rollback_and_return! result if result.error?

            updated_usages << result.payload
          end

          ServiceResponse.success(message: 'Updated runtime usage', payload: updated_usages)
        end
      end

      private

      def update_usage(usage)
        flow = Flow.includes(project: :namespace).find_by(id: usage_attribute(usage, :flow_id))
        return ServiceResponse.error(message: 'Flow not found', error_code: :flow_not_found) if flow.nil?

        day = usage_day(usage)
        amount = usage_amount(usage)
        return invalid_usage_error('Usage amount must be greater than zero') unless amount&.positive?

        db_usage = DailyRuntimeUsage.find_or_initialize_by(
          namespace: flow.project.namespace,
          flow: flow,
          day: day
        )

        return increment_usage(db_usage, amount) unless db_usage.persisted?

        db_usage.with_lock { increment_usage(db_usage, amount) }
      rescue ActiveRecord::RecordInvalid => e
        invalid_usage_error(e.record.errors)
      rescue ActiveRecord::RecordNotUnique
        retry
      rescue ArgumentError
        invalid_usage_error('Usage interval must be a valid date')
      end

      def usage_day(usage)
        value = usage_attribute(usage, :day, :date, :interval)
        return Time.zone.today if value.nil?

        case value
        when Date
          value
        when Time
          value.to_date
        when String
          Date.iso8601(value)
        else
          Time.zone.at(value.seconds).to_date if value.respond_to?(:seconds)
        end
      end

      def usage_amount(usage)
        value = usage_attribute(usage, :duration, :usage, :amount, :count)
        return if value.nil?

        BigDecimal(value.to_s)
      rescue ArgumentError
        nil
      end

      def increment_usage(db_usage, amount)
        db_usage.usage += amount
        return ServiceResponse.success(payload: db_usage) if db_usage.save

        invalid_usage_error(db_usage.errors)
      end

      def usage_attribute(usage, *keys)
        keys.each do |key|
          return usage.public_send(key) if usage.respond_to?(key)
          return usage[key] if usage.respond_to?(:key?) && usage.key?(key)
          return usage[key.to_s] if usage.respond_to?(:key?) && usage.key?(key.to_s)
        end

        nil
      end

      def invalid_usage_error(details)
        ServiceResponse.error(
          message: 'Failed to update runtime usage',
          error_code: :invalid_runtime_usage,
          details: details
        )
      end
    end
  end
end
