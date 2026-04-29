# frozen_string_literal: true

module EE
  module GlobalPolicy
    extend ActiveSupport::Concern

    prepended do
      rule { admin }.policy do
        enable :read_license
        enable :create_license
        enable :delete_license
      end
    end
  end
end
