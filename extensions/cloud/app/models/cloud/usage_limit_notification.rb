# frozen_string_literal: true

module CLOUD
  module UsageLimitNotification
    extend ActiveSupport::Concern

    prepended do
      # Cloud licenses are per-namespace, so every notification belongs to one. EE's
      # installation-wide notifications (namespace_id IS NULL) cannot occur here, which is why
      # the column stays nullable in the schema but is required by this model.
      validates :namespace, presence: true
    end
  end
end
