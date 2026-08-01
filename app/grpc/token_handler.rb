# frozen_string_literal: true

class TokenHandler < Tucana::Sagittarius::Rails::TokenService::Service
  include GrpcHandler

  # Called by the gateway to resolve an Aquila authentication token to a runtime_id, before it
  # mints its own JWT for subsequent calls into Rails.
  def verify(request, _call)
    runtime = Runtime.find_by(token: request.token)

    if runtime
      Tucana::Sagittarius::Rails::TokenVerifyResponse.new(
        verified: Tucana::Sagittarius::Rails::VerifiedRuntime.new(runtime_id: runtime.id)
      )
    else
      Tucana::Sagittarius::Rails::TokenVerifyResponse.new(
        unverified: Tucana::Sagittarius::Rails::UnverifiedRuntime.new
      )
    end
  end
end
