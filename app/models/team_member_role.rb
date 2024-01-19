# frozen_string_literal: true

class TeamMemberRole < ApplicationRecord
  belongs_to :role, class_name: 'TeamRole', inverse_of: :member_roles
  belongs_to :member, class_name: 'TeamMember', inverse_of: :member_roles
end
