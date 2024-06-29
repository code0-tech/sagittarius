# frozen_string_literal: true

class AuditEvent < ApplicationRecord
  ACTION_TYPES = {
    user_registered: 1,
    user_logged_in: 2,
    organization_created: 3,
    application_setting_updated: 4,
    namespace_role_created: 5,
    namespace_member_invited: 6,
    namespace_member_roles_updated: 7,
    namespace_role_abilities_updated: 8,
    namespace_role_updated: 9,
    organization_updated: 10,
    namespace_member_deleted: 11,
    organization_deleted: 12,
    namespace_role_deleted: 13,
    namespace_license_created: 14, # EE-specific
    namespace_project_created: 15,
    namespace_license_deleted: 16, # EE-specific
    namespace_project_deleted: 17,
    namespace_project_updated: 18,
    runtime_created: 19,
    runtime_updated: 20,
    runtime_deleted: 21,
  }.with_indifferent_access

  # rubocop:disable Lint/StructNewOverride
  GLOBAL_TARGET = Struct.new(:id, :class).new(0, Struct.new(:name).new('global'))
  # rubocop:enable Lint/StructNewOverride

  enum :action_type, ACTION_TYPES, prefix: :action

  belongs_to :author, class_name: 'User', inverse_of: :authored_audit_events, optional: true

  validates :author_id, presence: true, on: :create
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
