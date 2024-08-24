# frozen_string_literal: true

RSpec.configure do |config|
  server_instance = nil

  # we use `define_derived_metadata` to determine if any examples
  # have `need_grpc_server`. We don't use a before(need_grpc_server: true)
  # hook for that because we want to start the grpc server before any test
  # starts to run.
  config.define_derived_metadata do |metadata|
    metadata[:disable_transaction] = true if metadata[:need_grpc_server]

    if metadata[:need_grpc_server] && server_instance.nil?
      server_instance = Sagittarius::Grpc::Launcher.new
      server_instance.start
    end
  end

  config.after :suite do
    server_instance&.stop
  end
end
