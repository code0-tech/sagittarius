# frozen_string_literal: true

class OrganizationProject < ApplicationRecord
  belongs_to :organization, inverse_of: :projects

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :organization_id }

  validates :description, length: { maximum: 500 }, exclusion: { in: [nil] }

  before_validation :strip_whitespace

  private

  def strip_whitespace
    name&.strip!
    description&.strip!
  end
end
