# frozen_string_literal: true

class OrganizationLicense < ApplicationRecord
  belongs_to :organization, inverse_of: :organization_licenses

  validate :validate_license

  def validate_license
    loaded_license = license

    if loaded_license.nil?
      errors.add(:data, :invalid)
      return
    end

    errors.add(:data, :invalid) unless loaded_license.valid?
  end

  def license
    Code0::License.load(data)
  rescue Code0::License::Error
    nil
  end
end
