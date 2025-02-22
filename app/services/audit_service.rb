# frozen_string_literal: true

module AuditService
  module_function

  REQUIRED_EVENT_KEYS = %i[author_id entity_id entity_type details target_id target_type].freeze

  def audit(type, payload)
    Code0::ZeroTrack::Context.with_context do |context|
      payload[:author_id] ||= context[:user][:id]
      payload[:ip_address] = context[:ip_address]

      if payload.key?(:entity)
        entity = payload.delete(:entity)
        payload[:entity_id] = entity.id
        payload[:entity_type] = entity.class.name
      end

      if payload.key?(:target)
        target = payload.delete(:target)
        payload[:target_id] = target.id
        payload[:target_type] = target.class.name
      end

      missing_keys = REQUIRED_EVENT_KEYS.reject do |key|
        payload.key?(key)
      end

      raise InvalidAuditEvent, "Audit Event is missing the #{missing_keys} attributes" unless missing_keys.empty?

      AuditEvent.create!(
        action_type: type,
        **payload
      )
    end
  end

  class InvalidAuditEvent < StandardError; end
end
