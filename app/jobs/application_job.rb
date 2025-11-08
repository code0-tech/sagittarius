# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include Code0::ZeroTrack::Loggable
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  ActiveJob::Base.instance_eval do
    retry_on StandardError, wait: :polynomially_longer, attempts: 10

    before_enqueue do |job|
      possible_context = job.arguments.last
      next if possible_context.is_a?(Hash) && possible_context&.try(:key?, :sagittarius_context)

      job.arguments << Code0::ZeroTrack::Context.current.to_h.merge(sagittarius_context: true)
    end

    around_perform do |job, block|
      context = job.arguments.pop
      context.delete(:sagittarius_context)
      source_application = context.fetch(Code0::ZeroTrack::Context.log_key(:application), nil)
      Code0::ZeroTrack::Context.with_context(
        **context,
        application: 'good_job',
        source_application: source_application,
        job_id: job.job_id,
        job_class: self.class.name
      ) do
        block.call
      end
    end
  end
end
