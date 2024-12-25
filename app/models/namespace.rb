# frozen_string_literal: true

class Namespace < ApplicationRecord
  belongs_to :parent, polymorphic: true

  has_many :roles, class_name: 'NamespaceRole', inverse_of: :namespace

  has_many :namespace_members, inverse_of: :namespace
  has_many :users, through: :namespace_members, inverse_of: :namespaces

  has_many :projects, class_name: 'NamespaceProject', inverse_of: :namespace

  has_many :runtimes, inverse_of: :namespace

  has_many :data_types, inverse_of: :namespace

  def organization_type?
    parent_type == Organization.name
  end

  def user_type?
    parent_type == User.name
  end

  # rubocop:disable Naming/PredicateName
  def has_owner?
    user_type?
  end
  # rubocop:enable Naming/PredicateName

  def member?(user)
    return false if user.nil?

    if namespace_members.loaded?
      namespace_members.any? { |member| member.user.id == user.id }
    else
      namespace_members.exists?(user: user)
    end
  end
end

Namespace.prepend_extensions
