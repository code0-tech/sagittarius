# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Code0::ZeroTrack::Loggable

  def find_authentication(authorization)
    return Sagittarius::Authentication.new(:none, nil) if authorization.blank?

    token_type, token = authorization.split(' ', 2)

    create_authentication(token_type, token)
  end

  protected

  def create_authentication(token_type, token)
    case token_type
    when 'Session'
      Sagittarius::Authentication.new(:session, UserSession.find_by(token: token, active: true))
    else
      Sagittarius::Authentication.new(:invalid, nil)
    end
  end
end

ApplicationController.prepend_extensions
