# frozen_string_literal: true

module CLOUD
  module ApplicationController
    include Sagittarius::Override

    CraterLoginToken = Struct.new(:user, keyword_init: true)
    CraterToken = Struct.new(:user, keyword_init: true)

    override :create_authentication
    def create_authentication(token_type, token)
      if token_type == 'Crater-Login'
        user = ::User.find_by_token_for(:crater_login, token)

        if user.present?
          return Sagittarius::Authentication.new(
            :crater_login,
            CraterLoginToken.new(user: user)
          )
        end
      end

      if token_type == 'Crater'
        crater_config = Sagittarius::Configuration.config[:crater]
        claims = CLOUD::CraterJwt.verify(token, secret: crater_config[:jwt_secret],
                                                ttl_minutes: crater_config[:jwt_ttl_minutes])

        if claims.present?
          user = crater_authenticated_user(claims)

          if user.present?
            return Sagittarius::Authentication.new(
              :crater,
              CraterToken.new(user: user)
            )
          end
        end
      end

      super
    end

    private

    # A `sub` claim lets Crater act on behalf of a specific user so permission checks reflect
    # that user's real access. A `sub` that fails to resolve must never fall back to the
    # generic crater account - that would be a privilege escalation.
    def crater_authenticated_user(claims)
      return ::User.find_by(user_type: :crater) if claims['sub'].blank?

      user_id = Integer(claims['sub'])
      ::User.find_by(id: user_id, blocked_at: nil)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
