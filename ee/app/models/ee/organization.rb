# frozen_string_literal: true

module EE
  module Organization
    extend ActiveSupport::Concern

    prepended do
      has_many :organization_licenses, inverse_of: :organization
    end
  end
end
