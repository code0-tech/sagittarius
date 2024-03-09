# frozen_string_literal: true

class OrganizationMember < ApplicationRecord
  belongs_to :organization, inverse_of: :organization_members
  belongs_to :user, inverse_of: :organization_memberships

  has_many :member_roles, class_name: 'OrganizationMemberRole', inverse_of: :member
  has_many :roles, class_name: 'OrganizationRole', through: :member_roles, inverse_of: :members

  validates :organization, uniqueness: { scope: :user_id }
end
