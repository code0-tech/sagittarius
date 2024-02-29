# frozen_string_literal: true

class TeamRoleAbility < ApplicationRecord
  ABILITIES = {
    create_team_role: 1,
    invite_member: 2,
    assign_member_roles: 3,
  }.with_indifferent_access

  enum :ability, ABILITIES, prefix: :can

  belongs_to :team_role, inverse_of: :abilities

  validates :ability, presence: true,
                      inclusion: {
                        in: ABILITIES.keys.map(&:to_s),
                      },
                      uniqueness: { scope: :team_role_id }
end
