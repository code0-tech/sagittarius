# frozen_string_literal: true

class OrganizationRole < ApplicationRecord
  belongs_to :organization, inverse_of: :roles

  has_many :abilities, class_name: 'OrganizationRoleAbility', inverse_of: :organization_role
  has_many :member_roles, class_name: 'OrganizationMemberRole', inverse_of: :role
  has_many :members, class_name: 'OrganizationMember', through: :member_roles, inverse_of: :roles

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :organization_id }
end
