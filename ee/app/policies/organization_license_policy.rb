# frozen_string_literal: true

class OrganizationLicensePolicy < BasePolicy
  delegate { @subject.organization }
end
