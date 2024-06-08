# frozen_string_literal: true

class Namespace < ApplicationRecord
  belongs_to :parent, polymorphic: true

  validates :parent, presence: true

  def organization_type?
    parent_type == Organization.name
  end
end
