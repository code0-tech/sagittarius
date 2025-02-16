# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    authorization_token = request.headers['Authorization']

    current_authentication = find_authentication(authorization_token)

    return head :unauthorized if authorization_token.present? == current_authentication.none?
    return head :unauthorized if current_authentication.invalid?
    return head :forbidden if !current_authentication.mutations_allowed? && mutation? && !anonymous_mutation?

    current_user = current_authentication.authentication&.user

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_authentication: current_authentication,
    }

    Code0::ZeroTrack::Context.with_context(user: { id: current_user&.id, username: current_user&.username }) do
      result = SagittariusSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
      render json: result
    rescue StandardError => e
      logger.error message: e.message, backtrace: e.backtrace, exception_class: e.class

      if Rails.env.local?
        render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} },
               status: :internal_server_error
      else
        render json: { message: 'Internal server error' }, status: :internal_server_error
      end
    end
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def find_authentication(authorization)
    return Sagittarius::Authentication.new(:none, nil) if authorization.blank?

    token_type, token = authorization.split(' ', 2)

    case token_type
    when 'Session'
      Sagittarius::Authentication.new(:session, UserSession.find_by(token: token, active: true))
    else
      Sagittarius::Authentication.new(:invalid, nil)
    end
  end

  def query(query_string = params[:query], operation_name = params[:operationName])
    @query ||= ::GraphQL::Query.new(SagittariusSchema, query_string, operation_name: operation_name)
  end

  def mutation?
    query.mutation?
  end

  def anonymous_mutation?
    selections = query.selected_operation.selections
    return false unless selections.length == 1

    mutation_name = selections.first.name
    %w[usersLogin usersRegister usersIdentityRegister usersIdentityLogin].include?(mutation_name)
  end
end
