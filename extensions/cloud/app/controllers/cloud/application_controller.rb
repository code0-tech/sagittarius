# frozen_string_literal: true

module CLOUD
  module ApplicationController
    include Sagittarius::Override

    CraterLoginToken = Struct.new(:user, keyword_init: true)

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

      super
    end
  end
end
