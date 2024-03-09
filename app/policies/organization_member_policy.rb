# frozen_string_literal: true

class OrganizationMemberPolicy < BasePolicy
  delegate { @subject.organization }
end
