# frozen_string_literal: true

FactoryBot.define do
  factory :audit_event do
    author factory: :user
    action_type { nil }
    details { {} }
    ip_address { nil }

    transient do
      entity { nil }
      target { nil }
    end

    after(:build) do |event, context|
      event.entity_id = context.entity.id
      event.entity_type = context.entity.class.name
      event.target_id = context.target.id
      event.target_type = context.target.class.name
    end
  end
end
