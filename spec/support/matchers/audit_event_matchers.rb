# frozen_string_literal: true

RSpec::Matchers.define :create_audit_event do |type, payload = {}|
  payload.fetch(:details, {}).transform_keys!(&:to_s)

  match do |event_proc|
    before_last_id = 0

    if event_proc.is_a?(Proc)
      before_last_id = AuditEvent.where(action_type: type).last&.id || 0
      event_proc.call
    end

    new_events = AuditEvent.where(action_type: type, id: before_last_id..)

    new_events.any? do |event|
      payload.all? do |key, value|
        values_match?(value, event.send(key))
      end
    end
  end

  failure_message do |_|
    message = []

    message << "did not create audit event of type <#{type}>"
    message << "with payload: <#{payload.inspect}>"

    message.join("\n")
  end

  supports_block_expectations
end
