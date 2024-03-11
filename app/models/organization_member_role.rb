# frozen_string_literal: true

class OrganizationMemberRole < ApplicationRecord
  belongs_to :role, class_name: 'OrganizationRole', inverse_of: :member_roles
  belongs_to :member, class_name: 'OrganizationMember', inverse_of: :member_roles
end
