# frozen_string_literal: true

class Organization < ApplicationRecord
  include NamespaceParent

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }
end
