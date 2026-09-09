# frozen_string_literal: true

class UserNamespacePin < ApplicationRecord
  belongs_to :user, inverse_of: :user_namespace_pins
  belongs_to :namespace, inverse_of: :user_namespace_pins

  validates :priority, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                       uniqueness: { scope: :user_id }
  validates :namespace_id, uniqueness: { scope: :user_id }
end
