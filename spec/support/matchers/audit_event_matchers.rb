# frozen_string_literal: true

RSpec::Matchers.define :create_audit_event do |type = nil, payload = {}|
  payload.fetch(:details, {}).transform_keys!(&:to_s)
  before_last_id = 0

  match do |event_proc|
    scope = AuditEvent.all
    scope = scope.where(action_type: type) unless type.nil?

    if event_proc.is_a?(Proc)
      before_last_id = scope.last&.id&.+(1) || 0
      event_proc.call
    end

    new_events = scope.where(id: before_last_id..)

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

  failure_message_when_negated do
    message = []

    new_events = AuditEvent.where(id: before_last_id..)
    unless new_events.empty?
      message << 'Expected no new audit events.'
      message << 'Following audit events where created:'
      new_events.each do |event|
        message << event.inspect
      end
    end

    message.join("\n")
  end

  supports_block_expectations
end
