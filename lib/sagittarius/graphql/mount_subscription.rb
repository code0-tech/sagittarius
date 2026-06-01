# frozen_string_literal: true

module Sagittarius
  module Graphql
    module MountSubscription
      extend ActiveSupport::Concern

      class_methods do
        def mount_subscription(subscription_class, **custom_kwargs)
          # Using an underscored field name symbol will make `graphql-ruby`
          # standardize the field name
          field subscription_class.graphql_name.underscore.to_sym,
                subscription: subscription_class,
                **custom_kwargs
        end

        def mount_aliased_subscription(alias_name, subscription_class, **custom_kwargs)
          aliased_subscription_class = Class.new(subscription_class) do
            graphql_name alias_name
          end

          mount_subscription(aliased_subscription_class, **custom_kwargs)
        end
      end
    end
  end
end
