# frozen_string_literal: true

class NamespaceMemberRole < ApplicationRecord
  belongs_to :role, class_name: 'NamespaceRole', inverse_of: :member_roles
  belongs_to :member, class_name: 'NamespaceMember', inverse_of: :member_roles
end
