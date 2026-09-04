# frozen_string_literal: true

module CLOUD
  module BasePolicy
    extend ActiveSupport::Concern

    prepended do
      condition(:crater_login) { authentication.crater_login? }

      rule { crater_login }.prevent_all do
        except :read_user
      end

      condition(:crater) { authentication.crater? }

      rule { crater }.prevent_all do
        except :read_namespace
        except :read_license
        except :create_license
        except :delete_license
      end
    end
  end
end
