# frozen_string_literal: true

module Subscriptions
  class BaseSubscription < GraphQL::Schema::Subscription
    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject

    def current_authentication
      context[:current_authentication]
    end

    def self.generate_payload_type
      result = super
      result.graphql_name("#{graphql_name}SubscriptionPayload")
      result
    end
  end
end
