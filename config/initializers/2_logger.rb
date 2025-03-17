# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.formatter = Lograge::Formatters::Raw.new # let formatting be done by our own formatter
end

Rails.logger.formatter = Code0::ZeroTrack::Logs::JsonFormatter::Tagged.new

Rails.logger.broadcast_to ActiveSupport::Logger.new($stdout, formatter: Rails.logger.formatter) unless Rails.env.test?

Rails.logger.level = Sagittarius::Configuration.config[:rails][:log_level]

Rails.application.config.colorize_logging = Rails.const_defined? 'Console'

module GrpcLogger
  delegate :logger, to: :Rails
end

GRPC.extend GrpcLogger
