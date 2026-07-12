# frozen_string_literal: true

class Namespace < ApplicationRecord
  PERSONAL_NAMESPACE_ADMINISTRATOR_ROLE_NAME = 'Administrator'

  belongs_to :parent, polymorphic: true

  has_many :roles, class_name: 'NamespaceRole', inverse_of: :namespace

  has_many :namespace_members, inverse_of: :namespace
  has_many :users, through: :namespace_members, inverse_of: :namespaces

  has_many :projects, class_name: 'NamespaceProject', inverse_of: :namespace

  has_many :runtimes, inverse_of: :namespace

  def organization_type?
    parent_type == Organization.name
  end

  def user_type?
    parent_type == User.name
  end

  def owner?
    user_type?
  end

  def member?(user)
    return false if user.nil?

    if namespace_members.loaded?
      namespace_members.any? { |member| member.user.id == user.id }
    else
      namespace_members.exists?(user: user)
    end
  end

  def personal_namespace_owner_member?(member)
    user_type? && member&.namespace_id == id && member.user_id == parent_id
  end

  def personal_namespace_owner_administrator_role?(role)
    return false unless user_type? && role&.namespace_id == id

    role.members.exists?(id: personal_namespace_owner_member&.id) &&
      role.abilities.exists?(ability: :namespace_administrator)
  end

  def ensure_personal_namespace_administrator!
    return unless user_type?

    role = roles.find_or_create_by!(name: PERSONAL_NAMESPACE_ADMINISTRATOR_ROLE_NAME)
    role.abilities.find_or_create_by!(ability: :namespace_administrator)

    member = namespace_members.find_or_create_by!(user_id: parent_id)
    member.member_roles.find_or_create_by!(role: role)
  end

  private

  def personal_namespace_owner_member
    namespace_members.find_by(user_id: parent_id)
  end
end

Namespace.prepend_extensions
