# frozen_string_literal: true

class OrganizationRolePolicy < BasePolicy
  delegate { @subject.organization }
end
