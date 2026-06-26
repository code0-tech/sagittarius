# frozen_string_literal: true

class ServiceResponse
  include Code0::ZeroTrack::Loggable

  def self.success(message: nil, payload: nil)
    new(status: :success, message: message, payload: payload)
  end

  def self.error(message: nil, error_code: nil, details: nil)
    raise ArgumentError, 'error_code must be provided for error responses' if error_code.nil?

    ErrorCode.validate_error_code!(error_code)

    new(status: :error, message: message,
        payload: { error_code: error_code, details: details })
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

    payload[:details] = if payload[:details].is_a?(ActiveModel::Errors)
                          payload[:details].errors
                        else
                          Array.wrap(payload[:details]).map do |message|
                            case message
                            when String
                              { message: message }
                            else
                              raise "Unsupported error detail type: #{message.class.name}"
                            end
                          end
                        end

    { success_key => nil,
      errors: [Sagittarius::Graphql::ErrorContainer.new(payload[:error_code], payload[:details])] }
  end

  def to_grpc_response(proto_class, **additional_kwargs)
    if error?
      d = if payload[:details].is_a?(ActiveModel::Errors)
            payload[:details].errors.map do |e|
              Tucana::Shared::ServiceErrorDetails.new(
                active_model_error: Tucana::Shared::ServiceActiveModelError.new(
                  attribute: e.attribute,
                  type: e.type
                )
              )
            end
          else
            # Tucana does not support any details except active model errors (as of 0.0.75)
            []
          end

      additional_kwargs[:error] ||= Tucana::Shared::ServiceError.new(
        message: message,
        details: d
      )
    end
    proto_class.new(
      success: success?,
      **additional_kwargs
    )
  end
end
