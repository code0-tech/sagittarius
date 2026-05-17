# frozen_string_literal: true

module EE
  module Users
    module Identity
      module RegisterService
        include Sagittarius::Override
        include EE::Users::ValidateUserLimit

        override :validate_user_limit!
      end
    end
  end
end
