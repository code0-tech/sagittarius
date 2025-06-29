# frozen_string_literal: true

class NamespaceRoleAbility < ApplicationRecord
  ABILITIES = {
    create_namespace_role: { db: 1, description: 'Allows the creation of roles in a namespace' },
    invite_member: { db: 2, description: 'Allows to invite new members to a namespace' },
    assign_member_roles: { db: 3, description: 'Allows to change the roles of a namespace member' },
    assign_role_abilities: { db: 4, description: 'Allows to change the abilities of a namespace role' },
    update_namespace_role: { db: 5, description: 'Allows to update the namespace role' },
    update_organization: { db: 6, description: 'Allows to update the organization' },
    delete_member: { db: 7, description: 'Allows to remove members of a namespace' },
    delete_organization: { db: 8, description: 'Allows to delete the organization' },
    delete_namespace_role: { db: 9, description: 'Allows the deletion of roles in a namespace' },
    namespace_administrator: { db: 10, description: 'Allows to perform any action in the namespace' },
    create_namespace_license: { db: 11, description: 'Allows to create a license for the namespace' }, # EE-specific
    read_namespace_license: { db: 12, description: 'Allows to read the license of the namespace' }, # EE-specific
    create_namespace_project: { db: 13, description: 'Allows to create a project in the namespace' },
    read_namespace_project: { db: 14, description: 'Allows to read the project of the namespace' },
    delete_namespace_license: { db: 15, description: 'Allows to delete the license of the namespace' }, # EE-specific
    update_namespace_project: { db: 16, description: 'Allows to update the project of the namespace' },
    delete_namespace_project: { db: 17, description: 'Allows to delete the project of the namespace' },
    create_runtime: { db: 18, description: 'Allows to create a runtime globally or for the namespace' },
    update_runtime: { db: 19, description: 'Allows to update a runtime globally or for the namespace' },
    delete_runtime: { db: 20, description: 'Allows to delete a runtime' },
    rotate_runtime_token: { db: 21, description: 'Allows to regenerate a runtime token' },
    assign_role_projects: { db: 22, description: 'Allows to change the assigned projects of a namespace role' },
    assign_project_runtimes: { db: 23, description: 'Allows to assign runtimes to a project in the namespace' },
    create_flows: { db: 24, description: 'Allows to create flows in a namespace project' },
    delete_flows: { db: 25, description: 'Allows to delete flows in a namespace project' },
    update_flows: { db: 26, description: 'Allows to update flows in the project' },
  }.with_indifferent_access
  enum :ability, ABILITIES.transform_values { |v| v[:db] }, prefix: :can

  belongs_to :namespace_role, inverse_of: :abilities, class_name: 'NamespaceRole'

  validates :ability, presence: true,
                      inclusion: {
                        in: ABILITIES.keys.map(&:to_s),
                      },
                      uniqueness: { scope: :namespace_role_id }
end
