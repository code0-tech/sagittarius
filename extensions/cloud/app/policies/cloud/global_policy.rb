# frozen_string_literal: true

module CLOUD
  module GlobalPolicy
    extend ActiveSupport::Concern

    prepended do
      rule { crater }.enable :create_guest_user
    end
  end
end
