# frozen_string_literal: true

module CLOUD
  module BasePolicy
    extend ActiveSupport::Concern

    prepended do
      condition(:crater_login) { authentication.crater_login? }

      rule { crater_login }.prevent_all do
        except :read_user
      end
    end
  end
end
