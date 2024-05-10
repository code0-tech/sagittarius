# frozen_string_literal: true

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
  expected_field_names = Array.wrap(expected).flatten.map { |name| GraphqlHelpers.graphql_field_name(name) }

  @allow_extra = false
  @allow_extra_if_extended = false

  chain :at_least do
    @allow_extra = true
  end

  chain :allow_unexpected_if_extended do
    @allow_extra_if_extended = true
  end

  match do |kls|
    keys   = kls.fields.keys.to_set
    fields = expected_field_names.to_set

    next true if fields == keys
    next true if @allow_extra && fields.proper_subset?(keys)
    next true if @allow_extra_if_extended && fields.proper_subset?(keys) && InjectExtensions.extended_constants[kls]

    false
  end

  failure_message do |kls|
    missing = expected_field_names - kls.fields.keys
    extra = kls.fields.keys - expected_field_names

    message = []

    extra_allowed = @allow_extra || (@allow_extra_if_extended && InjectExtensions.extended_constants[kls])

    message << "is missing fields: <#{missing.inspect}>" if missing.any?
    message << "contained unexpected fields: <#{extra.inspect}>" if extra.any? && !extra_allowed

    message.join("\n")
  end
end
