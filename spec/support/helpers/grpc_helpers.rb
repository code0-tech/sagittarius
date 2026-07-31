# frozen_string_literal: true

module GrpcHelpers
  def create_stub(service_class)
    service_class.const_get('Stub').new(Sagittarius::Grpc::Launcher::HOST, :this_channel_is_insecure)
  end

  def authorization(runtime = create(:runtime))
    {
      metadata: {
        authorization: gateway_jwt(runtime),
      },
    }
  end

  def gateway_jwt(runtime = create(:runtime))
    gateway_config = Sagittarius::Configuration.config[:rails][:gateway]

    Sagittarius::Grpc::GatewayJwt.encode(
      runtime&.id,
      secret: gateway_config[:jwt_secret],
      ttl_seconds: gateway_config[:jwt_ttl_seconds]
    )
  end
end
