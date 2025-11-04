# frozen_string_literal: true

class OrganizationsFinder < ApplicationFinder
  def execute
    organizations = base_scope
    organizations = by_id(organizations)
    organizations = by_name(organizations)
    organizations = by_namespace_member_user(organizations)

    super(organizations)
  end

  private

  def base_scope
    Organization.all
  end

  def by_id(organizations)
    return organizations unless params[:id]

    organizations.where(id: params[:id])
  end

  def by_name(organizations)
    return organizations unless params[:name]

    organizations.where(name: params[:name])
  end

  def by_namespace_member_user(organizations)
    return organizations unless params.key?(:namespace_member_user)
    return Organization.none if params[:namespace_member_user].nil?

    namespaces = NamespaceMember.where(user_id: params[:namespace_member_user][:id]).select(:namespace_id)

    organizations.where(
      id: Namespace.where(id: namespaces, parent_type: 'Organization').select(:parent_id)
    )
  end
end
