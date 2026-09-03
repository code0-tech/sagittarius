# frozen_string_literal: true

class BasePolicy < DeclarativePolicy::Base
  class InvalidUserError < StandardError
  end

  def initialize(user, subject, opts = {})
    super
    return if user.is_a?(Sagittarius::Authentication)

    raise InvalidUserError, "Only #{Sagittarius::Authentication} is supported as user. Received #{user.class}"
  end

  def authentication
    @user # in declarative-policy this is the user, but we pass a wrapper object for more metadata
  end

  # rubocop:disable-next Rails/Delegate -- this breaks the graphql:compile_docs task if using delegate
  def user
    authentication.user
  end

  condition(:anonymous) { authentication.nil? || authentication.type == :none }
  condition(:admin) { user&.admin? }
end

BasePolicy.prepend_extensions
