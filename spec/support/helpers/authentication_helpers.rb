# frozen_string_literal: true

module AuthenticationHelpers
  UserContainer = Struct.new(:user)

  def create_authentication(subject, type = nil)
    if type.nil?
      case subject
      when User
        type = :test
        subject = UserContainer.new(subject)
      when UserSession
        type = :session
      when NilClass
        type = :none
      end
    end

    Sagittarius::Authentication.new(type, subject)
  end

  def authorization_token(current_user)
    session = UserSession.find_by(user: current_user, active: true)
    session = create(:user_session, user: current_user) if session.nil?

    session.token
  end
end
