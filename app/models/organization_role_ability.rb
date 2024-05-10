# frozen_string_literal: true

class OrganizationRoleAbility < ApplicationRecord
  # rubocop:disable Layout/LineLength
  ABILITIES = {
    create_organization_role: { db: 1, description: 'Allows the creation of roles in an organization' },
    invite_member: { db: 2, description: 'Allows to invite new members to an organization' },
    assign_member_roles: { db: 3, description: 'Allows to change the roles of an organization member' },
    assign_role_abilities: { db: 4, description: 'Allows to change the abilities of an organization role' },
    update_organization_role: { db: 5, description: 'Allows to update the organization role' },
    update_organization: { db: 6, description: 'Allows to update the organization' },
    delete_member: { db: 7, description: 'Allows to remove members of an organization' },
    delete_organization: { db: 8, description: 'Allows to delete the organization' },
    delete_organization_role: { db: 9, description: 'Allows the deletion of roles in an organization' },
    organization_administrator: { db: 10, description: 'Allows to perform any action in the organization' },
    create_organization_license: { db: 11, description: 'Allows to create a license for the organization' }, # EE-specific
    read_organization_license: { db: 12, description: 'Allows to read the license of the organization' }, # EE-specific
    delete_organization_license: { db: 13, description: 'Allows to delete the license of the organization' }, # EE-specific
  }.with_indifferent_access
  # rubocop:enable Layout/LineLength

  enum :ability, ABILITIES.transform_values { |v| v[:db] }, prefix: :can

  belongs_to :organization_role, inverse_of: :abilities

  validates :ability, presence: true,
                      inclusion: {
                        in: ABILITIES.keys.map(&:to_s),
                      },
                      uniqueness: { scope: :organization_role_id }
end
