# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }

  has_many :organization_members, inverse_of: :organization
  has_many :users, through: :organization_members, inverse_of: :organizations

  has_many :roles, class_name: 'OrganizationRole', inverse_of: :organization

  def bypass_permission?(user)
    return false if user.nil?
    return false if member?(user)

    organization_members.find_by!(user: user).role.abilities.includes(:organization_administrator)
  end

  def member?(user)
    return false if user.nil?

    if organization_members.loaded?
      organization_members.any? { |member| member.user.id == user.id }
    else
      organization_members.exists?(user: user)
    end
  end
end
