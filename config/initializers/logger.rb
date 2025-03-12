# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.formatter = Lograge::Formatters::Raw.new # let formatting be done by our own formatter
end

Rails.logger.formatter = Code0::ZeroTrack::Logs::JsonFormatter::Tagged.new

Rails.application.config.colorize_logging = Rails.const_defined? 'Console'

module GrpcLogger
  def logger
    Rails.logger
  end
end

GRPC.extend GrpcLogger
