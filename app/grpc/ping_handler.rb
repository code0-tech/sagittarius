# frozen_string_literal: true

class PingHandler < Tucana::Internal::PingService::Service
  include GrpcHandler

  def ping(request, _call)
    Tucana::Internal::PingMessage.new(ping_id: request.ping_id)
  end
end
