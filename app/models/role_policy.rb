# frozen_string_literal: true

class RolePolicy < ApplicationRecord
  belongs_to :policy, inverse_of: :role_policies
  belongs_to :role, inverse_of: :role_policies
end
