# frozen_string_literal: true

class OrganizationRoleAbility < ApplicationRecord
  ABILITIES = {
    create_organization_role: { db: 1, description: 'Allows the creation of roles in an organization' },
    invite_member: { db: 2, description: 'Allows to invite new members to an organization' },
    assign_member_roles: { db: 3, description: 'Allows to change the roles of an organization member' },
    assign_role_abilities: { db: 4, description: 'Allows to change the abilities of an organization role' },
    delete_member: { db: 5, description: 'Allows to remove members of an organization' },
    update_organization_role: { db: 6, description: 'Allows to update the organization role' },
  }.with_indifferent_access

  enum :ability, ABILITIES.transform_values { |v| v[:db] }, prefix: :can

  belongs_to :organization_role, inverse_of: :abilities

  validates :ability, presence: true,
                      inclusion: {
                        in: ABILITIES.keys.map(&:to_s),
                      },
                      uniqueness: { scope: :organization_role_id }
end
