# frozen_string_literal: true

class UserProjectPin < ApplicationRecord
  belongs_to :user, inverse_of: :user_project_pins
  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :user_project_pins

  validates :priority, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                       uniqueness: { scope: :user_id }
  validates :project_id, uniqueness: { scope: :user_id }
end
