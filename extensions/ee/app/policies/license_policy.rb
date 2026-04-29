# frozen_string_literal: true

class LicensePolicy < BasePolicy
  delegate { :global }
end

LicensePolicy.prepend_extensions
