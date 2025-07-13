# frozen_string_literal: true

require 'grpc/health/v1/health_services_pb'

class HealthHandler < Grpc::Health::V1::Health::Service
  include GrpcHandler

  def check(req, _call)
    return Grpc::Health::V1::HealthCheckResponse.new(status: :SERVING) if req.service == 'liveness'

    if req.service == 'readiness'
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        connection.execute('SELECT pg_backend_pid();')
        return Grpc::Health::V1::HealthCheckResponse.new(status: :SERVING)
      rescue PG::Error, ActiveRecord::ActiveRecordError
        return Grpc::Health::V1::HealthCheckResponse.new(status: :NOT_SERVING)
      end
    end

    raise GRPC::BadStatus.new_status_exception(GRPC::Core::StatusCodes::NOT_FOUND, 'Unknown service')
  end
end
