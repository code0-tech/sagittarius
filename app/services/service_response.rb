# frozen_string_literal: true

class ServiceResponse
  def self.success(message: nil, payload: nil)
    new(status: :success, message: message, payload: payload)
  end

  def self.error(message: nil, error_code: nil, details: nil)
    raise ArgumentError, 'error_code must be provided for error responses' if error_code.nil?

    ErrorCode.validate_error_code!(error_code)

    new(status: :error, message: message, payload: { error_code: error_code, details: details })
  end

  attr_reader :status, :message, :payload

  def initialize(status:, message:, payload:)
    @status = status
    @message = message
    @payload = payload
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end

  delegate :[], to: :to_h

  def to_h
    if payload.respond_to? :merge
      return payload.merge(
        status: status,
        message: message
      )
    end
    {
      payload: payload,
      status: status,
      message: message,
    }
  end

  def to_mutation_response(success_key: :object)
    return { success_key => payload, errors: [] } if success?
    return { success_key => nil, errors: payload } if payload&.details.is_a?(ActiveModel::Errors)

    payload.details = Array.wrap(payload&.details).map do |message|
      case message
      when String
        Sagittarius::Graphql::ErrorMessageContainer.new(message: message)
      when Symbol
        Sagittarius::Graphql::ServiceResponseErrorContainer.new(error_code: message)
      end
    end

    { success_key => nil, errors: payload }
  end
end
