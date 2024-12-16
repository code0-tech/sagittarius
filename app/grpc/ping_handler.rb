# frozen_string_literal: true

class PingHandler < Tucana::Sagittarius::PingService::Service
  include GrpcHandler

  def ping(request, _call)
    Tucana::Sagittarius::PingMessage.new(ping_id: request.ping_id)
  end
end
