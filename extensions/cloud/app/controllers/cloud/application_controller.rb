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

        if CLOUD::CraterJwt.valid?(token, secret: crater_config[:jwt_secret],
                                          ttl_minutes: crater_config[:jwt_ttl_minutes])
          user = ::User.find_by(user_type: :crater)

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
  end
end
