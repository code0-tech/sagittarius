# frozen_string_literal: true

class Organization < ApplicationRecord
  include NamespaceParent

  has_many :user_organization_pins, inverse_of: :organization

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }
end
