# frozen_string_literal: true

class OrganizationMemberRolePolicy < BasePolicy
  delegate { @subject.role.organization }
end
