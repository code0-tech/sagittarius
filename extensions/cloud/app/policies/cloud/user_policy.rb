# frozen_string_literal: true

module CLOUD
  module UserPolicy
    extend ActiveSupport::Concern

    prepended do
      condition(:crater_user) { user&.crater? }

      rule { crater_user }.policy do
        enable :update_user_custom_attribute
      end
    end
  end
end
