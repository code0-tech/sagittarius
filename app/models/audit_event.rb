# frozen_string_literal: true

class AuditEvent < ApplicationRecord
  ACTION_TYPES = {
    user_registered: 1,
    user_logged_in: 2,
    team_created: 3,
    application_setting_updated: 4,
    organization_role_created: 5,
    organization_member_invited: 6,
    organization_member_roles_updated: 7,
    organization_role_abilities_updated: 8,
  }.with_indifferent_access

  enum :action_type, ACTION_TYPES, prefix: :action

  belongs_to :author, class_name: 'User', inverse_of: :authored_audit_events

  validates :entity_id, presence: true
  validates :entity_type, presence: true
  validates :action_type, presence: true,
                          inclusion: {
                            in: ACTION_TYPES.keys.map(&:to_s),
                          }
  validate :validate_details
  validates :target_id, presence: true
  validates :target_type, presence: true

  def validate_details
    errors.add(:details, :blank) if details.nil?

    errors.add(:details, :invalid) unless details.is_a?(Hash)
  end
end
