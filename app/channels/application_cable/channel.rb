# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribe_to_channel
      with_context { super }
    end

    def perform_action(data)
      with_context { super }
    end

    protected

    def find_authentication(authorization)
      return Sagittarius::Authentication.new(:none, nil) if authorization.blank?

      token_type, token = authorization.split(' ', 2)

      create_authentication(token_type, token)
    end

    def create_authentication(token_type, token)
      case token_type
      when 'Session'
        Sagittarius::Authentication.new(:session, UserSession.joins(:user).find_by(token: token, active: true,
                                                                                   users: { blocked_at: nil }))
      else
        Sagittarius::Authentication.new(:invalid, nil)
      end
    end

    def with_context(&block)
      Code0::ZeroTrack::Context.with_context(
        application: 'cable',
        ip_address: request_ip,
        &block
      )
    end

    def request_ip
      return unless connection.respond_to?(:env)

      ::Rack::Request.new(connection.env).ip
    end
  end
end
