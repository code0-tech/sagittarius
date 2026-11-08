# frozen_string_literal: true

module EE
  module Namespace
    extend ActiveSupport::Concern

    prepended do
      # Only ever populated on Cloud, whose licenses are per-namespace; EE's installation-wide
      # notifications have no namespace at all. The association lives here because the model
      # does (see UsageLimitNotification).
      has_many :usage_limit_notifications, inverse_of: :namespace
    end
  end
end
