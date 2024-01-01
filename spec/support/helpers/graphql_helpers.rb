# frozen_string_literal: true

module GraphqlHelpers
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
    headers = { authorization: "Session #{authorization_token(current_user)}" } unless current_user.nil?

    params = { query: query, variables: variables }

    post graphql_path, headers: headers, params: params

    return unless graphql_errors

    expect(graphql_errors).not_to include(a_hash_including('message' => 'Internal server error'))
    expect(graphql_errors).not_to include(
      a_hash_including('message' => a_string_including('Type mismatch on variable'))
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

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
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
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
  end

  def graphql_errors(body = parsed_response)
    body['errors']
  end

  def authorization_token(current_user)
    session = UserSession.find_by(user: current_user, active: true)
    session = create(:user_session, user: current_user) if session.nil?

    session.token
  end

  def expect_graphql_errors_to_be_empty
    return unless graphql_errors

    expect(graphql_errors).to be_empty
  end

  def error_query
    %(
      errors {
        ...on ActiveModelError {
          attribute
          type
        }
        ...on MessageError {
          message
        }
      }
    )
  end
end
