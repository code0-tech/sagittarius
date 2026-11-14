# frozen_string_literal: true

class NamespaceMember < ApplicationRecord
  belongs_to :namespace, inverse_of: :namespace_members
  belongs_to :user, inverse_of: :namespace_members

  has_many :namespace_member_roles, class_name: 'NamespaceMemberRole', inverse_of: :namespace_member
  has_many :namespace_roles, class_name: 'NamespaceRole', through: :namespace_member_roles,
                             source: :namespace_role, inverse_of: :namespace_members

  validates :namespace, uniqueness: { scope: :user_id }
end
