# frozen_string_literal: true

class ProjectsFinder < ApplicationFinder
  def execute
    projects = base_scope
    projects = by_id(projects)
    projects = by_namespace_member_user(projects)

    super(projects)
  end

  private

  def base_scope
    NamespaceProject.all
  end

  def by_id(projects)
    return projects unless params[:id]

    projects.where(id: params[:id])
  end

  def by_namespace_member_user(projects)
    return projects unless params.key?(:namespace_member_user)
    return NamespaceProject.none if params[:namespace_member_user].nil?

    projects.where(
      namespace_id: NamespaceMember.where(user_id: params[:namespace_member_user][:id]).select(:namespace_id)
    )
  end
end
