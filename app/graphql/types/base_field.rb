# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def require_one_of(arguments)
      validates required: { one_of: arguments, message: "Only one of #{arguments.inspect} should be provided" }
    end

    def initialize(**kwargs, &block)
      @authorize = Array.wrap(kwargs.delete(:authorize))
      @visibility_profile = Array.wrap(kwargs.delete(:visibility_profile))

      super
    end

    def authorized?(object, _args, context)
      object = object.node if object.is_a?(GraphQL::Pagination::Connection::Edge)
      subject = object.try(:declarative_policy_subject) || object

      @authorize.all? do |ability|
        Ability.allowed?(context[:current_authentication], ability, subject)
      end
    end

    def visible?(context)
      super && (
        @visibility_profile.empty? ||
          context[:visibility_profile] == :full ||
          @visibility_profile.include?(context[:visibility_profile])
      )
    end
  end
end
