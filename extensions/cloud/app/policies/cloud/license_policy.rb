# frozen_string_literal: true

module CLOUD
  module LicensePolicy
    extend ActiveSupport::Concern

    prepended do
      delegate { subject.namespace }
    end
  end
end
