# frozen_string_literal: true

module CLOUD
  module User
    include Sagittarius::Override
    extend ActiveSupport::Concern

    prepended do
      generates_token_for :crater_login, expires_in: 10.minutes

      # Invalidated once the guest sets a real password during profile completion.
      generates_token_for :guest_claim, expires_in: 7.days do
        password_digest&.last(20)
      end
    end

    override :deletion_restriction
    def deletion_restriction
      return :active_subscription if user_custom_attributes.exists?(key: 'active_subscription')

      super
    end
  end
end
