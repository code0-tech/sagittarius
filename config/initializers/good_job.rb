# frozen_string_literal: true

Rails.application.config.to_prepare do
  if GoodJob::CLI.within_exe?
    Rails.logger.broadcast_to ActiveSupport::Logger.new($stdout, formatter: Rails.logger.formatter)
  end

  GoodJob::LogSubscriber.prepend Sagittarius::Middleware::GoodJob::LogSubscriber
  GoodJob::LogSubscriber.reset_logger

  GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
    user = User.authenticate_by(username: username, password: password)
    user.present? && user.admin
  end

  GoodJob::Engine.middleware.use Rack::MethodOverride
  GoodJob::Engine.middleware.use ActionDispatch::Flash
  GoodJob::Engine.middleware.use ActionDispatch::Cookies
  GoodJob::Engine.middleware.use ActionDispatch::Session::CookieStore
end

if Rails.env.development?
  Rails.application.config.after_initialize do
    # rubocop:disable Lint/Void -- Eager load ActiveRecord and ActiveJob so that GoodJob will start properly
    ActiveRecord::Base
    ActiveJob::Base
    # rubocop:enable Lint/Void
  end
end
