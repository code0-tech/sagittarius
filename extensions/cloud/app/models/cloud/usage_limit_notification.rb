# frozen_string_literal: true

module CLOUD
  module UsageLimitNotification
    extend ActiveSupport::Concern

    prepended do
      # Cloud licenses are per-namespace, so every notification belongs to one. EE's
      # installation-wide notifications are what keep the column nullable in the schema.
      belongs_to :namespace, inverse_of: :usage_limit_notifications
    end
  end
end
