# frozen_string_literal: true

module GraphqlHelpers
  include AuthenticationHelpers

  def self.graphql_field_name(underscored_field_name)
    return underscored_field_name.to_s if underscored_field_name.start_with?('_')

    underscored_field_name.to_s.camelize(:lower)
  end

  def self.deep_graphql_field_name(map)
    map.to_h do |k, v|
      [graphql_field_name(k), v.is_a?(Hash) ? deep_graphql_field_name(v) : v]
    end
  end

  def post_graphql(query, variables: {}, current_user: nil, headers: {})
    local_headers = headers
    unless current_user.nil?
      local_headers = local_headers.merge({ authorization: "Session #{authorization_token(current_user)}" })
    end
    local_headers = local_headers.merge({ 'content-type': 'application/json' })

    params = { query: query, variables: variables }.to_json

    post graphql_path, headers: local_headers, params: params

    return unless graphql_errors

    expect(graphql_errors).not_to include(a_hash_including('message' => 'Internal server error'))
    expect(graphql_errors).not_to include(
      a_hash_including('message' => a_string_including('Type mismatch on variable'))
    )
    expect(graphql_errors).not_to include(
      a_hash_including('message' => a_string_including("isn't a defined input type"))
    )
    expect(graphql_errors).not_to include(a_hash_including('backtrace'))
  end

  def parsed_response
    response.parsed_body
  end

  def graphql_data(body = parsed_response)
    body['data']
  end

  def graphql_data_at(*path)
    graphql_dig_at(graphql_data, *path)
  end

  def graphql_dig_at(data, *path)
    keys = path.map { |segment| segment.is_a?(Integer) ? segment : GraphqlHelpers.graphql_field_name(segment) }

    keys.reduce(data) do |acc, cur|
      if acc.is_a?(Array) && cur.is_a?(Integer)
        acc[cur]
      elsif acc.is_a?(Array)
        acc.compact.pluck(cur)
      else
        acc&.dig(cur)
      end
    end
  end

  def graphql_errors(body = parsed_response)
    body['errors']
  end

  def expect_graphql_errors_to_be_empty
    return unless graphql_errors

    expect(graphql_errors).to be_empty
  end

  def error_query
    %(
      errors {
        errorCode
			  details {
				  ...on ActiveModelError { attribute type }
				  ...on MessageError { message }
			  }
      }
    )
  end

  # Wrapper around a_hash_including that supports unpacking with **
  class UnpackableMatcher < SimpleDelegator
    include RSpec::Matchers

    attr_reader :to_hash

    def initialize(hash)
      @to_hash = hash
      super(a_hash_including(hash))
    end

    def to_json(_opts = {})
      to_hash.to_json
    end

    def as_json(opts = {})
      to_hash.as_json(opts)
    end
  end

  def a_graphql_entity_for(model = nil, *fields, **attrs)
    raise ArgumentError, 'model is nil' if model.nil? && fields.any?

    attrs.transform_keys! { |k| GraphqlHelpers.graphql_field_name(k) }
    attrs['id'] = model.to_global_id.to_s if model
    fields.each do |name|
      attrs[GraphqlHelpers.graphql_field_name(name)] = model.public_send(name)
    end

    raise ArgumentError, 'no attributes' if attrs.empty?

    UnpackableMatcher.new(attrs)
  end
end
