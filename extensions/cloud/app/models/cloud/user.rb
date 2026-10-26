# frozen_string_literal: true

module CLOUD
  module User
    include Sagittarius::Override
    extend ActiveSupport::Concern

    prepended do
      generates_token_for :crater_login, expires_in: 10.minutes

      generates_token_for :guest_claim do
        password_digest&.last(20)
      end
    end

    ACTIVE_CUSTOMER_KEY = 'active_customer'

    override :deletion_restriction
    def deletion_restriction
      return :active_customer if user_custom_attributes.find_by(key: ACTIVE_CUSTOMER_KEY)&.value

      super
    end
  end
end
