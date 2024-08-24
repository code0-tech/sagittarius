# frozen_string_literal: true

module GrpcHelpers
  def create_stub(service_class)
    service_class.const_get('Stub').new(Sagittarius::Grpc::Launcher::HOST, :this_channel_is_insecure)
  end

  def authorization(runtime = create(:runtime))
    {
      metadata: {
        authorization: runtime&.token,
      },
    }
  end
end
