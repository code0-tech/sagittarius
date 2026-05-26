# frozen_string_literal: true

module CLOUD
  module User
    extend ActiveSupport::Concern

    prepended do
      generates_token_for :crater_login, expires_in: 10.minutes
    end
  end
end
