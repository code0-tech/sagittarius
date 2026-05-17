# frozen_string_literal: true

class License < ApplicationRecord
  include Code0::ZeroTrack::Memoize

  scope :latest_first, -> { reorder(id: :desc) }
  scope :last_fifty, -> { latest_first.limit(50) }

  validate :validate_license

  class << self
    include Code0::ZeroTrack::Memoize

    def current
      load_license
    end

    def load_license
      last_fifty.find do |license|
        license.license.in_active_time?
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

  def start_date
    license&.start_date
  end

  def end_date
    license&.end_date
  end

  def licensee
    license&.licensee
  end

  def restrictions
    license&.restrictions
  end

  def restricted?(attribute)
    license&.restricted?(attribute)
  end
end

License.prepend_extensions
