# frozen_string_literal: true

module Sagittarius
  module RspecMatchers
    class GraphqlMatcherHelper
      def have_graphql_fields(kls, expected, allow_extra: false, allow_extra_if_extended: false)
        expected_field_names = Array.wrap(expected).flatten.map { |name| GraphqlHelpers.graphql_field_name(name) }

        {
          match: lambda do
            keys   = kls.fields.keys.to_set
            fields = expected_field_names.to_set

            next true if fields == keys
            next true if allow_extra && fields.proper_subset?(keys)
            if allow_extra_if_extended && fields.proper_subset?(keys) && InjectExtensions.extended_constants[kls]
              next true
            end

            false
          end,
          message: lambda do
            missing = expected_field_names - kls.fields.keys
            extra = kls.fields.keys - expected_field_names

            message = []

            extra_allowed = allow_extra || (allow_extra_if_extended && InjectExtensions.extended_constants[kls])

            message << "is missing fields: <#{missing.inspect}>" if missing.any?
            message << "contained unexpected fields: <#{extra.inspect}>" if extra.any? && !extra_allowed

            message.join("\n")
          end,
        }
      end
    end
  end
end

RSpec::Matchers.define :require_graphql_authorizations do |*expected|
  match do |klass|
    expect(klass.authorize).to match_array(expected.compact)
  end

  failure_message do |klass|
    actual = klass.authorize
    missing = expected - actual
    extra = actual - expected

    message = []
    message << "is missing permissions: #{missing.inspect}" if missing.any?
    message << "contained unexpected permissions: #{extra.inspect}" if extra.any?

    message.join("\n")
  end
end

RSpec::Matchers.define :have_graphql_fields do |*expected|
  @allow_extra = false
  @allow_extra_if_extended = false

  chain :at_least do
    @allow_extra = true
  end

  chain :allow_unexpected_if_extended do
    @allow_extra_if_extended = true
  end

  matcher_helper = Sagittarius::RspecMatchers::GraphqlMatcherHelper.new

  match do |kls|
    matcher_helper.have_graphql_fields(
      kls,
      expected,
      allow_extra: @allow_extra,
      allow_extra_if_extended: @allow_extra_if_extended
    )[:match].call
  end

  failure_message do |kls|
    matcher_helper.have_graphql_fields(
      kls,
      expected,
      allow_extra: @allow_extra,
      allow_extra_if_extended: @allow_extra_if_extended
    )[:message].call
  end
end

RSpec::Matchers.define :expose_abilities do |*expected|
  matcher_helper = Sagittarius::RspecMatchers::GraphqlMatcherHelper.new

  match do |kls|
    type_class = SagittariusSchema.types["#{kls.graphql_name}UserAbilities"]
    matcher_helper.have_graphql_fields(
      type_class,
      expected,
      allow_extra: InjectExtensions.extended_constants[kls].present?
    )[:match].call
  end

  failure_message do |kls|
    type_class = SagittariusSchema.types["#{kls.graphql_name}UserAbilities"]
    matcher_helper.have_graphql_fields(
      type_class,
      expected,
      allow_extra: InjectExtensions.extended_constants[kls].present?
    )[:message].call
  end
end

RSpec::Matchers.define :have_visibility_profile do |*expected|
  match do |field|
    expect(field.instance_variable_get(:@visibility_profile)).to match_array(expected.compact)
  end

  failure_message do |field|
    actual = field.instance_variable_get(:@visibility_profile)
    missing = expected - actual
    extra = actual - expected

    message = []
    message << "is missing visibility profiles: #{missing.inspect}" if missing.any?
    message << "contained unexpected visibility profiles: #{extra.inspect}" if extra.any?

    message.join("\n")
  end
end
