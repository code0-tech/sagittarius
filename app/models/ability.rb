# frozen_string_literal: true

module Ability
  module_function

  def allowed?(user, ability, subject = :global)
    policy = policy_for(user, subject)

    policy.allowed?(ability)
  end

  def policy_for(user, subject = :global)
    Cache.policies ||= {}

    DeclarativePolicy.policy_for(user, subject, cache: Cache.policies)
  end

  class Cache < ActiveSupport::CurrentAttributes
    attribute :policies
  end
end
