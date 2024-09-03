# frozen_string_literal: true

class UserIdentity < ApplicationRecord

  belongs_to :user, inverse_of: :user_identities

  validates :provider_id, presence: true
  validates :identifier, presence: true


  validates :identifier, uniqueness: { scope: :provider_id }

end
