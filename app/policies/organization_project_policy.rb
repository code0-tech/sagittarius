# frozen_string_literal: true

class OrganizationProjectPolicy < BasePolicy
  delegate { @subject.organization }
end
