# frozen_string_literal: true

RSpec::Matchers.define :create_audit_event do |type, payload = {}|
  payload.fetch(:details, {}).transform_keys!(&:to_s)
  before_last_id = 0

  match do |event_proc|
    if event_proc.is_a?(Proc)
      before_last_id = AuditEvent.where(action_type: type).last&.id&.+(1) || 0
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

    new_events = AuditEvent.where(id: before_last_id..)
    unless new_events.empty?
      message << ''
      message << 'Following audit events where created:'
      new_events.each do |event|
        message << event.inspect
      end
    end

    message.join("\n")
  end

  supports_block_expectations
end
