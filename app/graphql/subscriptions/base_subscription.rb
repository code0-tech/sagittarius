# frozen_string_literal: true

module Subscriptions
  class BaseSubscription < GraphQL::Schema::Subscription
    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject

    def self.inherited(subclass)
      super
      subclass.graphql_name subclass.name.delete_prefix('Subscriptions::').gsub('::', '')
    end

    def self.generate_payload_type
      result = super
      result.graphql_name("#{graphql_name}SubscriptionPayload")
      result
    end

    def current_authentication
      context[:current_authentication]
    end
  end
end
