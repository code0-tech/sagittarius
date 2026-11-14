# frozen_string_literal: true

class NamespaceMemberRole < ApplicationRecord
  belongs_to :namespace_role, class_name: 'NamespaceRole', foreign_key: :role_id,
                              inverse_of: :namespace_member_roles
  belongs_to :namespace_member, class_name: 'NamespaceMember', foreign_key: :member_id,
                                inverse_of: :namespace_member_roles
end
