# frozen_string_literal: true

class OrganizationLicense < ApplicationRecord
  belongs_to :organization, inverse_of: :organization_licenses
end
