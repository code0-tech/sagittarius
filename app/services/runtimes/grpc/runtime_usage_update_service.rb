# frozen_string_literal: true

module Runtimes
  module Grpc
    class RuntimeUsageUpdateService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :runtime, :usages

      def initialize(runtime:, usages:)
        @runtime = runtime
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
        return runtime_assignment_error(flow) unless runtime_assigned_to_flow?(flow)

        day = usage_day(usage)
        amount = usage_amount(usage)
        return invalid_usage_error('Usage amount must be greater than zero') unless amount&.positive?

        db_usage, created = find_or_create_usage(flow, day, amount)

        return ServiceResponse.success(payload: db_usage) if created

        # rubocop:disable Rails/SkipsModelValidations -- amount is validated above; this keeps the increment atomic in SQL.
        DailyRuntimeUsage.update_counters(db_usage.id, usage: amount, touch: true)
        # rubocop:enable Rails/SkipsModelValidations
        ServiceResponse.success(payload: db_usage.reload)
      rescue ActiveRecord::RecordInvalid => e
        invalid_usage_error(e.record.errors)
      rescue ArgumentError
        invalid_usage_error('Usage interval must be a valid date')
      end

      def find_or_create_usage(flow, day, amount)
        attributes = {
          namespace: flow.project.namespace,
          flow: flow,
          day: day,
        }

        db_usage = DailyRuntimeUsage.find_by(attributes)
        return [db_usage, false] if db_usage.present?

        db_usage = nil
        DailyRuntimeUsage.transaction(requires_new: true) do
          db_usage = DailyRuntimeUsage.create!(attributes.merge(usage: amount))
        end

        [db_usage, true]
      rescue ActiveRecord::RecordNotUnique
        retry
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

      def runtime_assigned_to_flow?(flow)
        runtime.project_assignments.compatible.exists?(namespace_project: flow.project)
      end

      def runtime_assignment_error(flow)
        assignment = runtime.project_assignments.find_by(namespace_project: flow.project)
        if assignment.nil?
          return ServiceResponse.error(
            message: 'Runtime not assigned to flow project',
            error_code: :runtime_not_assigned
          )
        end

        ServiceResponse.error(message: 'Runtime not compatible with flow project', error_code: :runtime_not_compatible)
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
