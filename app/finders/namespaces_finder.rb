# frozen_string_literal: true

class NamespacesFinder < ApplicationFinder
  def execute
    namespaces = base_scope
    namespaces = by_id(namespaces)
    namespaces = by_namespace_member_user(namespaces)

    super(namespaces)
  end

  private

  def base_scope
    Namespace.all
  end

  def by_id(namespaces)
    return namespaces unless params[:id]

    namespaces.where(id: params[:id])
  end

  def by_namespace_member_user(namespaces)
    return namespaces unless params.key?(:namespace_member_user)
    return Namespace.none if params[:namespace_member_user].nil?

    namespaces.where(
      id: NamespaceMember.where(user_id: params[:namespace_member_user][:id]).select(:namespace_id)
    )
  end
end
