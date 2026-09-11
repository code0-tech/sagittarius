# frozen_string_literal: true

class UserProjectPin < ApplicationRecord
  belongs_to :user, inverse_of: :user_project_pins
  belongs_to :namespace, inverse_of: :user_project_pins
  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :user_project_pins

  validates :priority, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                       uniqueness: { scope: %i[user_id namespace_id] }
  validates :project_id, uniqueness: { scope: :user_id }
  validate :validate_namespace_matches_project

  private

  def validate_namespace_matches_project
    return if project.nil? || namespace_id == project.namespace_id

    errors.add(:namespace, :invalid_namespace, message: 'must match the namespace the project belongs to')
  end
end
