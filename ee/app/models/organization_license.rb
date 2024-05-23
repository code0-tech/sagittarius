# frozen_string_literal: true

class OrganizationLicense < ApplicationRecord
  include Sagittarius::Memoize

  belongs_to :organization, inverse_of: :organization_licenses

  scope :for_organization, ->(organization) { where(organization: organization) }
  scope :latest_first, -> { reorder(id: :desc) }
  scope :last_fifty, -> { latest_first.limit(50) }

  validate :validate_license

  class << self
    include Sagittarius::Memoize

    def current(organization)
      memoize(:current, reset_on_change: -> { organization.id }) do
        load_license(organization)
      end
    end

    def load_license(organization)
      for_organization(organization).last_fifty.find do |organization_license|
        organization_license.license.in_active_time?
      end
    end
  end

  def validate_license
    loaded_license = license

    if loaded_license.nil?
      errors.add(:data, :invalid)
      return
    end

    errors.add(:data, :invalid) unless loaded_license.valid?
  end

  def license
    memoize(:license, reset_on_change: -> { data }) { Code0::License.load(data) }
  rescue Code0::License::Error
    nil
  end

  def restrictions
    license&.restrictions
  end

  def restricted?(attribute)
    license&.restricted?(attribute)
  end
end
