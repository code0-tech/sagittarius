# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    description 'Root subscription type'

    include Sagittarius::Graphql::MountSubscription

    mount_subscription Subscriptions::Namespaces::Projects::Flows::ExecutionResult
    mount_subscription Subscriptions::AI::GenerateFlow
    mount_subscription Subscriptions::Echo
  end
end
