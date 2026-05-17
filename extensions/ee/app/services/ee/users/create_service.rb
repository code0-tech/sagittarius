# frozen_string_literal: true

module EE
  module Users
    module CreateService
      include Sagittarius::Override
      include EE::Users::ValidateUserLimit

      override :validate_user_limit!
    end
  end
end
