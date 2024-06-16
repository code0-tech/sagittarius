# frozen_string_literal: true

class NamespaceMember < ApplicationRecord
  belongs_to :namespace, inverse_of: :namespace_members
  belongs_to :user, inverse_of: :namespace_memberships

  has_many :member_roles, class_name: 'NamespaceMemberRole', inverse_of: :member
  has_many :roles, class_name: 'NamespaceRole', through: :member_roles, inverse_of: :members

  validates :namespace, uniqueness: { scope: :user_id }
end
