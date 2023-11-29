# frozen_string_literal: true

class Policy < ApplicationRecord
  belongs_to :permission, inverse_of: :policies
  has_many :role_policies, inverse_of: :policy
end
