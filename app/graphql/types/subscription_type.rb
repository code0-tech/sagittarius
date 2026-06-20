# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    description 'Root subscription type'

    include Sagittarius::Graphql::MountSubscription

    mount_subscription Subscriptions::Ai::GenerateFlow
    mount_subscription Subscriptions::Echo
    mount_subscription Subscriptions::Namespaces::Projects::Flows::ExecutionResult
  end
end
