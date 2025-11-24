# frozen_string_literal: true

{
  Owner: [:namespace_administrator],
  Maintainer: %i[
    create_namespace_project
    delete_namespace_project
    update_organization
    create_runtime
    update_runtime
    delete_runtime
  ],
  Member: %i[
    create_flow
    delete_flow
    update_flow
    read_namespace_project
    update_namespace_project
  ],
}.each do |name, abilities|
  role = NamespaceRole.seed_once :name, :namespace_id do |nr|
    nr.name = name
    nr.namespace_id = Organization.find_by(name: 'Code1').ensure_namespace&.id
  end
  next if role.first.nil?

  abilities.each do |ability|
    NamespaceRoleAbility.seed_once :namespace_role_id, :ability do |nra|
      nra.namespace_role_id = role.first&.id
      nra.ability = ability
    end
  end
end
